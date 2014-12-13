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
        subject.attributes = attrs

        if subject.changed?
          subject.audit_comment = 'Provisioned account for initial login'
          subject.save!
        end
      end
    end

    private

    def accept_invitation(session, attrs)
      invitation = Invitation.where(identifier: session[:invite])
                   .available.first!
      invitation.subject.accept(invitation, attrs)
      invitation.subject
    end
  end
end
