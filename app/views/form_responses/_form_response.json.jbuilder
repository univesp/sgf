json.extract! form_response, :id, :form_id, :user, :status, :json_response, :json_updated_at, :sent_at, :created_at, :updated_at
json.url form_response_url(form_response, format: :json)