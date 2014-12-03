FactoryGirl.define do
  factory :permitted_attribute do
    association :available_attribute
    association :provider
  end
end
