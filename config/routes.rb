Rails.application.routes.draw do
  root :to => 'home#index'

  resources :forms
  resources :form_responses
end
