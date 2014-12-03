require 'rails_helper'

RSpec.describe ProvidedAttribute do
  context 'validations' do
    let(:attr) { subject.permitted_attribute.available_attribute }
    subject { build(:provided_attribute) }

    it { is_expected.to validate_presence_of(:permitted_attribute) }
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to allow_value(attr.name).for(:name) }
    it { is_expected.not_to allow_value(attr.name + 'a').for(:name) }
    it { is_expected.to allow_value(attr.value).for(:value) }
    it { is_expected.not_to allow_value(attr.value + 'a').for(:value) }
  end
end
