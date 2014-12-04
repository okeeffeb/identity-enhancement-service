require 'rails_helper'

RSpec.describe APISubject, type: :model do
  context 'validations' do
    subject { build(:api_subject) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:x509_cn) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:contact_name) }
    it { is_expected.to validate_presence_of(:contact_mail) }

    it { is_expected.to allow_value('abcd').for(:x509_cn) }
    it { is_expected.not_to allow_value('abcd!').for(:x509_cn) }
    it { is_expected.not_to allow_value("abc\ndef").for(:x509_cn) }
  end
end
