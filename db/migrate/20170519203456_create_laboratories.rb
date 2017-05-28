class CreateLaboratories < ActiveRecord::Migration[5.0]
  def change
    create_table :laboratories do |t|
      t.string :name
      t.string :dep_name
      t.string :facilitador

      t.timestamps
    end
  end
end
