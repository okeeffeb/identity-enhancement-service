FactoryGirl.define do
  factory :available_attribute do
    name { Faker::Lorem.word }
    value { Faker::Lorem.words(5).join(':') }
    description { Faker::Lorem.sentence }
  end
end
