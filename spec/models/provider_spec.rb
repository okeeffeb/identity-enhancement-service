require 'rails_helper'

RSpec.describe Provider do
  context 'validations' do
    subject { build(:provider) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:identifier) }

    %W(aaf abcd1234_- #{'x' * 40}).each do |identifier|
      it { is_expected.to allow_value(identifier).for(:identifier) }
    end

    %W(aaf! abcd:1234 abc\ndef #{'x' * 41}).each do |identifier|
      it { is_expected.not_to allow_value(identifier).for(:identifier) }
    end
  end
end
