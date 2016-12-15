Rails.application.routes.draw do
    
  resources :forms
  resources :form_responses

  # Common
  # ----------------------------------------- #
  get '/' => 'form_vagas_remanescentes#index' # TODO: while there's not a home page
  get '/vagas-remanescentes' => 'form_vagas_remanescentes#index' # TODO: while there's not a home page
  get '/vagas-remanescentes/login' => 'form_vagas_remanescentes#login'


  # Form "Socioeconômico"
  # ----------------------------------------- #
  get '/vagas-remanescentes/socio' => 'form_vagas_remanescentes#socio_economico'
  post '/vagas-remanescentes/socio/submit' => 'form_vagas_remanescentes#socio_economico_submit'


  # Form "Pedido"
  # ----------------------------------------- #
  get '/vagas-remanescentes/classes-and-activities-by-course' => 'form_vagas_remanescentes#classes_and_activities_by_course'
  get '/vagas-remanescentes/pedido' => 'form_vagas_remanescentes#pedido'
  post '/vagas-remanescentes/pedido-submit-partial' => 'form_vagas_remanescentes#pedido_submit_partial'
  post '/vagas-remanescentes/pedido-submit-final' => 'form_vagas_remanescentes#pedido_submit_final'
  post '/vagas-remanescentes/upload' => 'form_vagas_remanescentes#upload'


  # Form "Final"
  # ----------------------------------------- #
  get '/vagas-remanescentes/final' => 'form_vagas_remanescentes#final'


  # OAuth
  # ----------------------------------------- #
  get '/new_user' => 'users#create_user_identity'
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  get '/auth/:provider/callback', to: 'users#create'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :put, :patch], :as => :finish_signup
  get '/logout', to: 'users#destroy', as: 'signout'

end
