Rails.application.routes.draw do
  mount RapidRack::Engine => '/auth'
  root to: 'welcome#index'
end
