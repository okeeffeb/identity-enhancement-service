require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:invitation) { create(:invitation) }
  subject { response }

  context 'get :index' do
    def run
      get :index
    end

    let(:permission) { 'admin:invitations:list' }
    it_behaves_like 'a restricted action'

    context 'as a permitted user' do
      let(:user) { create(:subject, :authorized) }
      before { session[:subject_id] = user.id }

      it 'lists the invitations' do
        invitation
        run
        expect(assigns[:invitations]).to include(invitation)
      end

      it do
        run
        is_expected.to render_template('invitations/index')
      end
    end
  end

  context 'post :create' do
    let(:provider) { create(:provider) }
    let(:permission) { 'admin:invitations:create' }
    it_behaves_like 'a restricted action'

    let(:attrs) do
      attributes_for(:subject).slice(:name, :mail)
        .merge(provider_id: provider.id)
    end

    def run
      post :create, invitation: attrs
    end

    context 'as a permitted user' do
      let(:user) { create(:subject, :authorized) }
      before { session[:subject_id] = user.id }

      it 'creates the subject' do
        expect { run }.to change(Subject, :count).by(1)
      end

      it 'creates the invitation' do
        expect { run }.to change(Invitation, :count).by(1)
      end

      it do
        run
        expect(response).to redirect_to(invitations_path)
      end
    end
  end

  context 'get :accept' do
    let(:user) { create(:subject) }

    def run
      get :accept, identifier: invitation.identifier
    end

    context 'for an invalid identifier' do
      it 'raises an error' do
        # Causes a 404 in production
        expect { get :accept, identifier: 'nonexistent' }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it 'assigns the invite code in the session' do
      expect { run }.to change { session[:invite] }.to(invitation.identifier)
    end

    it do
      run
      expect(response).to redirect_to('/auth/login')
    end
  end
end
