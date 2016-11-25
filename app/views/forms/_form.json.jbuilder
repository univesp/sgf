json.extract! form, :id, :reference_model, :description, :status, :open_at, :close_at, :max_attemps, :created_at, :updated_at
json.url form_url(form, format: :json)