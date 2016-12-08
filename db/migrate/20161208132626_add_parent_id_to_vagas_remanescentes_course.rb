class AddParentIdToVagasRemanescentesCourse < ActiveRecord::Migration[5.0]
  def change
    add_reference :vagas_remanescentes_courses, :parent, index: true
  end
end
