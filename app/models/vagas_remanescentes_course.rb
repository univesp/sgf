class VagasRemanescentesCourse < ApplicationRecord
  belongs_to :parent, class_name: 'VagasRemanescentesCourse', foreign_key: 'parent_id', optional: true
end
