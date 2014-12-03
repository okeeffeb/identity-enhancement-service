module Authentication
  class SubjectReceiver
    include RapidRack::DefaultReceiver
    include RapidRack::RedisRegistry

    def map_attributes(attrs)
      {
        targeted_id: attrs['edupersontargetedid'],
        shared_token: attrs['auedupersonsharedtoken'],
        name: attrs['displayname'],
        mail: attrs['mail']
      }
    end

    def subject(attrs)
      return accept_invitation(attrs.dup) if attrs.key?(:invite)

      Subject.find_or_initialize_by(attrs.slice(:targeted_id)).tap do |subject|
        subject.update_attributes!(
          attrs.merge(audit_comment: 'Provisioned account for initial login'))
      end
    end

    private

    def accept_invitation(attrs)
      invitation = Invitation.where(identifier: attrs.delete(:invite))
                   .available.first!

      Invitation.transaction do
        invitation.subject.tap do |subject|
          subject.update_attributes!(attrs.merge(complete: true))
          invitation.update_attributes!(used: true)
        end
      end
    end
  end
end
