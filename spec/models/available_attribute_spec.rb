require 'rails_helper'

RSpec.describe AvailableAttribute do
  context 'validations' do
    subject { build(:available_attribute) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:description) }

    it { is_expected.to allow_value('eduPersonEntitlement').for(:name) }
    it { is_expected.not_to allow_value(Faker::Lorem.word).for(:name) }

    let(:value) { 'urn:mace:aaf.edu.au:ide:researcher:1' }
    it { is_expected.to allow_value(value).for(:value) }
    it { is_expected.not_to allow_value(value + '0').for(:value) }
  end
end
