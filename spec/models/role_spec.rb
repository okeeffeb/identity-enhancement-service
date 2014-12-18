require 'rails_helper'

require 'gumboot/shared_examples/roles'

RSpec.describe Role, type: :model do
  include_examples 'Roles'
  it_behaves_like 'an audited model'

  context 'validations' do
    subject { build(:role) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
