class CreateVagasRemanescentesCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :vagas_remanescentes_courses do |t|
      t.string :name

      t.timestamps
    end
  end
end
