class UpdateForeignKey < ActiveRecord::Migration[5.0]
  def change
  	remove_foreign_key :identities, :users
  	add_foreign_key :identities, :users, on_delete: :cascade
  end
end
