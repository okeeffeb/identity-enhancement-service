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
      Subject.find_or_initialize_by(attrs.slice(:targeted_id)).tap do |subject|
        subject.update_attributes!(attrs)
      end
    end
  end
end
