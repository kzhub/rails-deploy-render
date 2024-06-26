Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'pages#index'

  resources :users, only: %i[show new create]  do
    resources :attendances, only: %i[index new create update]  do
      resource :breaktimes_start, only: %i[create], controller: 'attendances/breaktimes_start'
      resource :breaktimes_end, only: %i[create], controller: 'attendances/breaktimes_end'
    end
  end
end
