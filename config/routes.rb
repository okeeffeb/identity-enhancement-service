Rails.application.routes.draw do
  mount RapidRack::Engine => '/auth'
  root to: 'welcome#index'

  resources :providers do
    resources :roles do
      resources :members, controller: 'subject_role_assignments',
                          only: %i(new create destroy)
    end

    resources :provided_attributes
  end

  resources :invitations, only: %i(index create show) do
    collection do
      get ':identifier' => 'invitations#show', as: 'show'
      post ':identifier' => 'invitations#accept', as: 'accept'
    end
  end

  scope '/admin' do
    resources :available_attributes do
      collection do
        get 'audits' => 'available_attributes#audits', as: 'audit'
      end
      member do
        get 'audits' => 'available_attributes#audits', as: 'audit'
      end
    end

    resources :subjects, only: %i(index show destroy) do
      member do
        get 'audits' => 'subjects#audits', as: 'audit'
      end
    end

    resources :providers, only: [] do
      resources :permitted_attributes, only: %i(index create destroy)
    end
  end
end
