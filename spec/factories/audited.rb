FactoryGirl.define do
  trait :audited do
    audit_comment { Faker::Lorem.sentence }
  end
end
