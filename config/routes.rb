Rails.application.routes.draw do
  mount RapidRack::Engine => '/auth'
  root to: 'welcome#index'

  resources :invitations, only: %i(index create) do
    collection do
      get ':identifier' => 'invitations#accept'
    end
  end
end
