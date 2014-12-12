Rails.application.routes.draw do
  mount RapidRack::Engine => '/auth'
  root to: 'welcome#index'

  resources :invitations, only: %i(index create show) do
    collection do
      get ':identifier' => 'invitations#show', as: 'show'
      post ':identifier' => 'invitations#accept', as: 'accept'
    end
  end

  scope '/admin' do
    resources :providers
    resources :available_attributes
  end
end
