Rails.application.routes.draw do
  resources :celebrations, path: '/deal/', only: [ :index ] do
    collection do
      post :celebration_webhook_call
      get :is_latest_deal_won
      get :details
    end
  end

  resources :tenants, only: [ :create ]

  resources :celebrations, path: '/', only: [] do
    collection do
      post :add_webhook
    end
  end

  root 'dashboard#index'
end
