class CreateVagasRemanescentesActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :vagas_remanescentes_activities do |t|
      t.string :name
      t.references :vagas_remanescentes_courses, foreign_key: true, index: { name: 'index_vagas_remanescentes_activities_on_courses_id' }

      t.timestamps
    end
  end
end
