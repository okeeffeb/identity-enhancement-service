FactoryGirl.define do
  factory :provided_attribute do
    association :permitted_attribute
    association :subject

    name { permitted_attribute.available_attribute.name }
    value { permitted_attribute.available_attribute.value }
  end
end
