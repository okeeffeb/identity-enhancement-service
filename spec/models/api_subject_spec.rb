require 'rails_helper'

require 'gumboot/shared_examples/api_subjects'

RSpec.describe APISubject, type: :model do
  include_examples 'API Subjects'
  it_behaves_like 'an audited model'

  context 'validations' do
    subject { build(:api_subject) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:x509_cn) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:contact_name) }
    it { is_expected.to validate_presence_of(:mail) }

    it { is_expected.to allow_value('abcd').for(:x509_cn) }
    it { is_expected.not_to allow_value('abcd!').for(:x509_cn) }
    it { is_expected.not_to allow_value("abc\ndef").for(:x509_cn) }
  end
end
