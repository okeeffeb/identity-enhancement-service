require 'rails_helper'

RSpec.describe AvailableAttribute, type: :model do
  it_behaves_like 'an audited model'

  context 'validations' do
    subject { build(:available_attribute) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:description) }

    it { is_expected.to allow_value('eduPersonEntitlement').for(:name) }
    it { is_expected.not_to allow_value(Faker::Lorem.word).for(:name) }

    let(:prefix) { 'urn:mace:aaf.edu.au:ide' }
    let(:suffix) { Faker::Lorem.words.join(':') }
    let(:value) { "#{prefix}:#{suffix}" }

    it { is_expected.to allow_value(value).for(:value) }
    it { is_expected.not_to allow_value(value.sub('ide', 'idp')).for(:value) }
  end
end
