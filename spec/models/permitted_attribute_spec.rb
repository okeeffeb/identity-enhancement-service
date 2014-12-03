require 'rails_helper'

RSpec.describe PermittedAttribute, type: :model do
  context 'validations' do
    subject { build(:permitted_attribute) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:available_attribute) }
  end
end
