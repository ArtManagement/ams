class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :warehouse
      t.integer :sort
      t.boolean :usable
      t.timestamps
    end
  end
end
