FactoryGirl.define do
  factory :permission, traits: %i(audited) do
    association :role
    value '*'
  end
end
