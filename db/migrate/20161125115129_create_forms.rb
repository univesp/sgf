class CreateForms < ActiveRecord::Migration[5.0]
  def change
    create_table :forms do |t|
      t.string :reference_model
      t.string :description
      t.string :status
      t.date :open_at
      t.date :close_at
      t.integer :max_attemps

      t.timestamps
    end
  end
end
