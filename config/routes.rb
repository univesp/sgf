Rails.application.routes.draw do
  root :to => 'home#index'

  resources :forms
  resources :form_responses
  
  get '/vagas-remanescentes' => 'form_vagas_remanescentes#index'
end
