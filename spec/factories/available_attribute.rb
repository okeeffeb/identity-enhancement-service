FactoryGirl.define do
  factory :available_attribute, traits: %i(audited) do
    name 'eduPersonEntitlement'
    value 'urn:mace:aaf.edu.au:ide:researcher:1'
    description { Faker::Lorem.sentence }
  end
end
