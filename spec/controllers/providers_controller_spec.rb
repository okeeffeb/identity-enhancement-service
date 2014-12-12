require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do
  let(:user) { create(:subject, :authorized, permission: 'admin:providers:*') }
  let(:orig_attrs) { attributes_for(:provider).except(:audit_comment) }
  let(:provider) { create(:provider, orig_attrs) }
  before { session[:subject_id] = user.try(:id) }
  subject { response }

  context 'get :index' do
    let!(:provider) { create(:provider) }
    before { get :index }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('providers/index') }
    it { is_expected.to have_assigned(:providers, include(provider)) }

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.to have_http_status(:forbidden) }
    end

    context 'with no user' do
      let(:user) { nil }
      before { get :index }
      it { is_expected.to redirect_to('/auth/login') }
    end
  end

  context 'get :new' do
    before { get :new }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('providers/new') }
    it { is_expected.to have_assigned(:provider, a_new(Provider)) }

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.to have_http_status(:forbidden) }
    end
  end

  context 'post :create' do
    def run
      post(:create, provider: attrs)
    end

    let(:attrs) { attributes_for(:provider) }
    subject { -> { run } }

    it { is_expected.to change(Provider, :count).by(1) }
    it { is_expected.to have_assigned(:provider, an_instance_of(Provider)) }

    context 'the response' do
      before { run }
      subject { response }

      it { is_expected.to redirect_to(providers_path) }
    end

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.not_to change(Provider, :count) }

      context 'the response' do
        before { run }
        subject { response }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  context 'get :show' do
    before { get :show, id: provider.id }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('providers/show') }
    it { is_expected.to have_assigned(:provider, provider) }

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.to have_http_status(:forbidden) }
    end
  end

  context 'get :edit' do
    before { get :edit, id: provider.id }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template('providers/edit') }
    it { is_expected.to have_assigned(:provider, provider) }

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.to have_http_status(:forbidden) }
    end
  end

  context 'patch :update' do
    let(:attrs) do
      attributes_for(:provider).slice(:name, :description, :identifier)
    end

    before { patch :update, id: provider.id, provider: attrs }
    subject { response }

    it { is_expected.to redirect_to(providers_path) }
    it { is_expected.to have_assigned(:provider, provider) }

    context 'the provider' do
      subject { provider.reload }
      it { is_expected.to have_attributes(attrs) }
    end

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.to have_http_status(:forbidden) }

      context 'the provider' do
        subject { provider.reload }
        it { is_expected.to have_attributes(orig_attrs) }
      end
    end
  end

  context 'post :destroy' do
    def run
      delete :destroy, id: provider.id
    end

    let!(:provider) { create(:provider) }
    subject { -> { run } }

    it { is_expected.to change(Provider, :count).by(-1) }
    it { is_expected.to have_assigned(:provider, provider) }

    context 'the response' do
      before { run }
      subject { response }
      it { is_expected.to redirect_to(providers_path) }
    end

    context 'as a non-admin' do
      let(:user) { create(:subject) }
      it { is_expected.not_to change(Provider, :count) }

      context 'the response' do
        before { run }
        subject { response }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end
end
