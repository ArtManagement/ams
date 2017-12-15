class CreateSales < ActiveRecord::Migration[5.0]
  def change
    create_table :sales do |t|
      t.integer :sale_slip_id
      t.integer :artwork_id
      t.integer :price
      t.text :note
      t.timestamps
    end
  end
end
