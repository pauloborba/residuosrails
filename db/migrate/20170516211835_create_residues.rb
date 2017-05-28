class CreateResidues < ActiveRecord::Migration[5.0]
  def change
    create_table :residues do |t|
      t.string  :name
      t.string  :laboratory
      t.integer :weight, default: 0
      t.string  :collection
      t.string  :type
      t.string  :composition

      t.timestamps
    end
  end
end
