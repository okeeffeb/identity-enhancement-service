require 'rails_helper'

RSpec.describe InvitationsController, type: :routing do
  let(:identifier) { SecureRandom.urlsafe_base64(19) }

  context 'get /admin/invitations' do
    subject { { get: '/admin/invitations' } }
    it { is_expected.to route_to('invitations#index') }
  end

  context 'get /providers/:id/invitations' do
    subject { { get: '/providers/1/invitations' } }
    it { is_expected.not_to be_routable }
  end

  context 'get /providers/:id/invitations/new' do
    subject { { get: '/providers/1/invitations/new' } }
    it { is_expected.to route_to('invitations#new', provider_id: '1') }
  end

  context 'post /providers/:id/invitations' do
    subject { { post: '/providers/1/invitations' } }
    it { is_expected.to route_to('invitations#create', provider_id: '1') }
  end

  context 'get /invitations/complete' do
    subject { { get: '/invitations/complete' } }
    it { is_expected.to route_to('invitations#complete') }
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
