require 'rails_helper'

RSpec.describe Role, type: :model do
  context 'validations' do
    subject { build(:role) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
