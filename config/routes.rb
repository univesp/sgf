Rails.application.routes.draw do
  root :to => 'home#index'

  resources :forms
  resources :form_responses
  
  get '/vagas-remanescentes' => 'form_vagas_remanescentes#index'
  get '/vagas-remanescentes/univesp-activities' => 'form_vagas_remanescentes#univesp_activities'
  get '/vagas-remanescentes/univesp-classes' => 'form_vagas_remanescentes#univesp-classes'
end
