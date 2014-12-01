require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def good
      check_access!('some:resource')
      render nothing: true
    end

    def bad
      render nothing: true
    end

    def public
      public_action
      render nothing: true
    end
  end

  before do
    @routes.draw do
      get '/anonymous/good' => 'anonymous#good'
      get '/anonymous/bad' => 'anonymous#bad'
      get '/anonymous/public' => 'anonymous#public'
    end
  end

  let(:user) { create(:subject, :authorized) }

  context 'after_action hook' do
    before { session[:subject_id] = user.id }

    it 'allows an action with access control' do
      expect { get :good }.not_to raise_error
    end

    it 'fails without access control' do
      msg = 'No access control performed by AnonymousController#bad'
      expect { get :bad }.to raise_error(msg)
    end

    it 'allows a public action' do
      expect { get :public }.not_to raise_error
    end
  end
end
