class CreateVagasRemanescentesClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :vagas_remanescentes_classes do |t|
      t.string :name
      t.references :vagas_remanescentes_course, foreign_key: true, index: { name: 'index_vagas_remanescentes_classes_on_courses_id' }

      t.timestamps
    end
  end
end
