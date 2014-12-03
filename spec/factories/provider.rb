FactoryGirl.define do
  factory :provider, traits: %i(audited) do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    identifier { name.gsub(/\W+/, '-') }
  end
end
