require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:invitation) { create(:invitation) }
  let!(:provider) { create(:provider) }
  subject { response }

  context 'get :index' do
    def run
      get :index
    end

    let!(:invitation) { create(:invitation) }
    let(:permission) { 'admin:invitations:list' }
    it_behaves_like 'a restricted action'

    context 'as a permitted user' do
      let(:user) { create(:subject, :authorized) }
      before do
        session[:subject_id] = user.id
        run
      end

      it 'lists the invitations' do
        expect(assigns[:invitations]).to include(invitation)
      end

      it 'lists the providers' do
        expect(assigns[:providers]).to include(provider)
      end

      it { is_expected.to render_template('invitations/index') }
    end
  end

  context 'get :new' do
    def run
      get :new, provider_id: provider.id
    end

    let(:permission) { "providers:#{provider.id}:invitations:create" }
    it_behaves_like 'a restricted action'

    context 'as a permitted user' do
      let(:user) { create(:subject, :authorized) }
      before do
        session[:subject_id] = user.id
        run
      end

      it { is_expected.to render_template('invitations/new') }

      it 'assigns the invitation' do
        expect(assigns[:invitation]).to be_a_new(Invitation)
      end
    end
  end

  context 'post :create' do
    let(:permission) { "providers:#{provider.id}:invitations:create" }
    it_behaves_like 'a restricted action'

    let(:attrs) do
      attributes_for(:subject).slice(:name, :mail)
        .merge(provider_id: provider.id)
    end

    def run
      post :create, provider_id: provider.id, invitation: attrs
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
        expect(response)
          .to redirect_to(provider_provided_attributes_path(provider))
      end

      context 'email delivery' do
        before { run }
        let(:text) { 'You have been invited to AAF Identity Enhancement' }
        it { is_expected.to have_sent_email.to(attrs[:mail]) }
        it { is_expected.to have_sent_email.matching_body(/#{text}/) }

        it 'links to the invitation in the message' do
          expected = %r{/invitations/#{Invitation.last.identifier}}
          expect(subject).to have_sent_email.matching_body(expected)
        end
      end

      context 'email failure' do
        before { expect(Mail).to receive(:deliver) { fail('Nope') } }

        it 'does not create a subject' do
          expect { run }.to raise_error.and not_change(Subject, :count)
        end

        it 'does not create a invitation' do
          expect { run }.to raise_error.and not_change(Invitation, :count)
        end
      end
    end
  end

  context 'get :show' do
    def run
      get :show, identifier: invitation.identifier
    end

    context 'for an invalid identifier' do
      it 'raises an error' do
        # Causes a 404 in production
        expect { get :show, identifier: 'nonexistent' }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for a used invite' do
      let(:invitation) { create(:invitation, used: true) }
      before { run }
      it { is_expected.to render_template('invitations/used') }
      it { is_expected.to have_assigned(:invitation, invitation) }
    end

    context 'for an expired invite' do
      let(:invitation) { create(:invitation, expires: 1.month.ago) }
      before { run }
      it { is_expected.to render_template('invitations/expired') }
      it { is_expected.to have_assigned(:invitation, invitation) }
    end

    context 'for a valid invite' do
      before { run }
      it { is_expected.to render_template('invitations/show') }
      it { is_expected.to have_assigned(:invitation, invitation) }
    end
  end

  context 'post :accept' do
    let(:user) { create(:subject) }

    def run
      post :accept, identifier: invitation.identifier
    end

    context 'for an invalid identifier' do
      it 'raises an error' do
        # Causes a 404 in production
        expect { post :accept, identifier: 'nonexistent' }
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
