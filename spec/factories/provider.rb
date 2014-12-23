FactoryGirl.define do
  factory :provider, traits: %i(audited) do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    identifier { SecureRandom.urlsafe_base64(22) }
  end
end
