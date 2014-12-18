require 'rails_helper'

RSpec.describe PermissionsHelper, type: :helper do
  let(:helper) do
    klass = Class.new do
      attr_writer :subject
      include PermissionsHelper
    end
    klass.new
  end

  let(:user) { create(:subject, :authorized, permission: 'a:b:c') }
  before { helper.subject = user }

  context '#if_permitted' do
    subject { ->(b) { helper.if_permitted(action, &b) } }

    context 'when permitted' do
      let(:action) { 'a:b:c' }
      it { is_expected.to yield_control }
    end

    context 'when denied' do
      let(:action) { 'something:else' }
      it { is_expected.not_to yield_control }
    end

    context 'when no subject' do
      before { helper.subject = nil }
      let(:action) { 'a:b:c' }
      it { is_expected.not_to yield_control }
    end
  end

  context '#unless_permitted' do
    subject { ->(b) { helper.unless_permitted(action, &b) } }

    context 'when permitted' do
      let(:action) { 'a:b:c' }
      it { is_expected.not_to yield_control }
    end

    context 'when denied' do
      let(:action) { 'something:else' }
      it { is_expected.to yield_control }
    end

    context 'when no subject' do
      before { helper.subject = nil }
      let(:action) { 'a:b:c' }
      it { is_expected.to yield_control }
    end
  end
end
