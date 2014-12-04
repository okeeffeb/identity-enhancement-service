FactoryGirl.define do
  factory :api_subject do
    association :provider
    x509_cn { SecureRandom.urlsafe_base64 }
    name { Faker::Company.name }
    description { Faker::Company.bs }
    contact_name { Faker::Name.name }
    contact_mail { Faker::Internet.email(contact_name) }

    trait :authorized do
      transient { permission '*' }

      after(:create) do |api_subject, attrs|
        perm = create(:permission, value: attrs.permission)
        api_subject.api_subject_role_assignments.create(role: perm.role)
      end
    end
  end
end
