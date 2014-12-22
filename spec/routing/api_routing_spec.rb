require 'rails_helper'

module API
  RSpec.describe API, type: :routing do
    context AttributesController do
      context '/api/attributes/:shared_token' do
        let(:aepst) { SecureRandom.urlsafe_base64(19) }
        subject { { get: "/api/attributes/#{aepst}" } }
        it 'routes to api/attributes#show' do
          expect(subject).to route_to('api/attributes#show',
                                      shared_token: aepst, format: 'json')
        end
      end
    end
  end
end
