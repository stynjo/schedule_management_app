Rails.application.routes.draw do
 
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  root 'static_pages#top'
                     
                                 
  resources :users 
  resources :attendances   
  resources :reserves
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
