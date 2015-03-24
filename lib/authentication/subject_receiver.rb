module Authentication
  class SubjectReceiver
    include RapidRack::DefaultReceiver
    include RapidRack::RedisRegistry

    def map_attributes(_env, attrs)
      {
        targeted_id: attrs['edupersontargetedid'],
        shared_token: attrs['auedupersonsharedtoken'],
        name: attrs['displayname'],
        mail: attrs['mail']
      }
    end

    def subject(env, attrs)
      session = env['rack.session']
      return accept_invitation(session, attrs) if session.try(:key?, :invite)

      Subject.find_or_initialize_by(attrs.slice(:targeted_id)).tap do |subject|
        update_subject(subject, attrs)
      end
    end

    def finish(env)
      if env['rack.session'].try(:delete, :invite)
        redirect_to('/invitations/complete')
      else
        redirect_to('/dashboard')
      end
    end

    private

    def accept_invitation(session, attrs)
      invitation = Invitation.where(identifier: session[:invite])
                   .available.first!

      Audited.audit_class.as_user(invitation.subject) do
        invitation.subject.accept(invitation, attrs)
      end

      invitation.subject
    end

    def update_subject(subject, attrs)
      subject.attributes = attrs.merge(complete: true)

      Audited.audit_class.as_user(subject) do
        if subject.new_record?
          subject.audit_comment = 'Provisioned account for initial login'
          subject.save!
        elsif subject.changed?
          subject.audit_comment = 'Updated attributes upon login'
          subject.save!
        end
      end
    end
  end
end
