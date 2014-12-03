FactoryGirl.define do
  factory :available_attribute do
    name 'eduPersonEntitlement'
    value 'urn:mace:aaf.edu.au:ide:researcher:1'
    description { Faker::Lorem.sentence }
  end
end
