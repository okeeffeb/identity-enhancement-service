require 'rails_helper'

module API
  RSpec.describe API, type: :routing do
    context AttributesController do
      context 'get /api/attributes/:shared_token' do
        let(:aepst) { SecureRandom.urlsafe_base64(19) }
        subject { { get: "/api/attributes/#{aepst}" } }
        it 'routes to api/attributes#show' do
          expect(subject).to route_to('api/attributes#show',
                                      shared_token: aepst, format: 'json')
        end
      end

      context 'get /api/attributes/:email_address' do
        subject { { get: "/api/attributes/#{Faker::Internet.email}" } }
        it { is_expected.not_to be_routable }
      end

      context 'post /api/attributes' do
        subject { { post: '/api/attributes' } }
        it { is_expected.to route_to('api/attributes#create', format: 'json') }
      end
    end
  end
end
