class CreateReceipts < ActiveRecord::Migration[5.0]
  def change
    create_table :receipts do |t|
      t.integer :receipt_slip_id
      t.integer :sale_id
      t.integer :amount
      t.text :note
      t.timestamps
    end
  end
end
