require 'rails_helper'

RSpec.describe SubjectRoleAssignment, type: :model do
  context 'validations' do
    subject { create(:subject, :authorized).subject_role_assignments.first! }

    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:role) }
  end
end
