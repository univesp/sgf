Rails.application.routes.draw do

  root :to => 'home#index'
    
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  get '/auth/:provider/callback', to: 'users#create'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get '/logout', to: 'users#destroy', as: 'signout'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
