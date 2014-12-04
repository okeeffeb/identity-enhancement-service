FactoryGirl.define do
  factory :subject do
    name { Faker::Name.name }
    mail { Faker::Internet.email(name) }
    shared_token { SecureRandom.urlsafe_base64(16) }
    targeted_id do
      "https://rapid.example.com!https://ide.example.com!#{SecureRandom.hex}"
    end

    trait :authorized do
      transient { permission '*' }

      after(:create) do |subject, attrs|
        perm = create(:permission, value: attrs.permission)
        subject.subject_role_assignments.create(role: perm.role)
      end
    end
  end
end