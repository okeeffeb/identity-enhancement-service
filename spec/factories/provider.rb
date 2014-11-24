FactoryGirl.define do
  factory :provider do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    identifier do
      ['urn:mace:x-aaf',
       *name.split(/\s+/).map(&:dasherize)
      ].join(':')
    end
  end
end
