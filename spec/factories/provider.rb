FactoryGirl.define do
  factory :provider do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    identifier { name.gsub(/\W+/, '-') }
  end
end
