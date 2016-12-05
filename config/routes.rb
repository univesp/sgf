Rails.application.routes.draw do

  root :to => 'home#index'
    
  resources :forms
  resources :form_responses
  
  get '/vagas-remanescentes' => 'form_vagas_remanescentes#index'
  get '/vagas-remanescentes/univesp-activities-by-course' => 'form_vagas_remanescentes#univesp_activities_by_course'
 
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  get '/auth/:provider/callback', to: 'users#create'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :put, :patch], :as => :finish_signup
  get '/logout', to: 'users#destroy', as: 'signout'
end
