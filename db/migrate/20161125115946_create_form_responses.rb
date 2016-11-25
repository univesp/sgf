class CreateFormResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :form_responses do |t|
      t.references :form, foreign_key: true
      t.string :user
      t.string :status
      t.string :json_response
      t.date :json_updated_at
      t.date :sent_at

      t.timestamps
    end
  end
end
