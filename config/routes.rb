Rails.application.routes.draw do
 
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  root 'users#show'
                     
                                 
  resources :users 
  
  resource :attendances do
    get 'date/:date', to: 'attendances#date'
    get '/index', to: 'attendances#index'
     collection { post :import }
  end
  resource :reserves do
    get '/index', to: 'reserves#index'
    get '/date', to: 'reserves#list'
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
