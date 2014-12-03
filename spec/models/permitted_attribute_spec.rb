require 'rails_helper'

RSpec.describe PermittedAttribute, type: :model do
  it_behaves_like 'an audited model'

  context 'validations' do
    subject { build(:permitted_attribute) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:available_attribute) }
  end
end
