require 'rails_helper'

RSpec.describe InvitationsController, type: :routing do
  let(:identifier) { SecureRandom.urlsafe_base64(19) }

  context 'get /invitations' do
    subject { { get: '/invitations' } }
    it { is_expected.to route_to('invitations#index') }
  end

  context 'post /invitations' do
    subject { { post: '/invitations' } }
    it { is_expected.to route_to('invitations#create') }
  end

  context 'get /invitations/:identifier' do
    subject { { get: "/invitations/#{identifier}" } }
    it { is_expected.to route_to('invitations#show', identifier: identifier) }
  end

  context 'post /invitations/:identifier' do
    subject { { post: "/invitations/#{identifier}" } }
    it { is_expected.to route_to('invitations#accept', identifier: identifier) }
  end
end
