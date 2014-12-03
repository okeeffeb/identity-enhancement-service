require 'rails_helper'

RSpec.describe InvitationsController, type: :routing do
  context 'get /invitations' do
    subject { { get: '/invitations' } }
    it { is_expected.to route_to('invitations#index') }
  end

  context 'post /invitations' do
    subject { { post: '/invitations' } }
    it { is_expected.to route_to('invitations#create') }
  end

  context 'get /invitations/:identifier' do
    let(:identifier) { SecureRandom.urlsafe_base64(19) }
    subject { { get: "/invitations/#{identifier}" } }
    it { is_expected.to route_to('invitations#accept', identifier: identifier) }
  end
end
