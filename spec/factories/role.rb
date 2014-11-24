FactoryGirl.define do
  factory :role do
    association :provider
    name { Faker::Lorem.sentence }
  end
end
