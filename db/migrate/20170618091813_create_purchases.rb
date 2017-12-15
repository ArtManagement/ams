class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.integer :purchase_slip_id
      t.integer :artwork_id
      t.integer :price
      t.text :note
      t.timestamps
    end
  end
end
