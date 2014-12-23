require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:subject, :authorized) }
  let(:role) { user.roles.first }
  let(:attribute) { create(:provided_attribute, subject: user) }

  before { session[:subject_id] = user.id }

  context 'get :index' do
    before { get :index }
    subject { response }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('dashboard/index') }
    it { is_expected.to have_assigned(:subject, user) }

    it 'builds a provider map' do
      expect(assigns[:provider_roles]).to include(role.provider => [role])
    end

    it 'sets the provided attributes' do
      expect(assigns[:provided_attributes]).to include(attribute)
    end
  end
end
