Rails.application.routes.draw do

  root :to => 'home#index'
    
  resources :forms
  resources :form_responses
  
  get '/vagas-remanescentes/socio' => 'form_vagas_remanescentes#socio_economico'
  get '/vagas-remanescentes/pedido' => 'form_vagas_remanescentes#index'
  post '/vagas-remanescentes/socio/submit' => 'form_vagas_remanescentes#socio_economico_submit'

  get '/vagas-remanescentes/univesp-classes' => 'form_vagas_remanescentes#univesp_classes'
  get '/vagas-remanescentes/classes-and-activities-by-course' => 'form_vagas_remanescentes#classes_and_activities_by_course'
  get '/vagas-remanescentes/login' => 'form_vagas_remanescentes#login'


  post '/vagas-remanescentes/save-response' => 'form_vagas_remanescentes#save_response'
  post '/vagas-remanescentes/upload' => 'form_vagas_remanescentes#upload'
 
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  get '/auth/:provider/callback', to: 'users#create'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :put, :patch], :as => :finish_signup
  get '/logout', to: 'users#destroy', as: 'signout'

end
