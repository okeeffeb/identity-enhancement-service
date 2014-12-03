require 'rails_helper'

RSpec.describe APISubjectRoleAssignment, type: :model do
  it_behaves_like 'an audited model'

  context 'validations' do
    subject do
      create(:api_subject, :authorized).api_subject_role_assignments.first!
    end

    it { is_expected.to validate_presence_of(:api_subject) }
    it { is_expected.to validate_presence_of(:role) }
  end
end
