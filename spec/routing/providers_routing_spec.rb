require 'rails_helper'

RSpec.describe ProvidersController, type: :routing do
  context 'get /admin/providers' do
    subject { { get: '/admin/providers' } }
    it { is_expected.to route_to('providers#index') }
  end

  context 'get /admin/providers/new' do
    subject { { get: '/admin/providers/new' } }
    it { is_expected.to route_to('providers#new') }
  end

  context 'post /admin/providers' do
    subject { { post: '/admin/providers' } }
    it { is_expected.to route_to('providers#create') }
  end

  context 'get /admin/providers/:id' do
    subject { { get: '/admin/providers/1' } }
    it { is_expected.to route_to('providers#show', id: '1') }
  end

  context 'get /admin/providers/:id/edit' do
    subject { { get: '/admin/providers/1/edit' } }
    it { is_expected.to route_to('providers#edit', id: '1') }
  end

  context 'patch /admin/providers/:id' do
    subject { { patch: '/admin/providers/1' } }
    it { is_expected.to route_to('providers#update', id: '1') }
  end

  context 'delete /admin/providers/:id' do
    subject { { delete: '/admin/providers/1' } }
    it { is_expected.to route_to('providers#destroy', id: '1') }
  end
end
