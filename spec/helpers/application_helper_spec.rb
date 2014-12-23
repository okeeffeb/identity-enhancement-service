require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  # TODO: Replace this with actual required behaviour.
  context '#environment_string' do
    subject { helper.environment_string }
    it { is_expected.to eq('Development') }
  end
end
