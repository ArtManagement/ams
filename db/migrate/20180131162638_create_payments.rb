class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :payment_slip_id
      t.integer :purchase_id
      t.integer :amount
      t.text :note
      t.timestamps
    end
  end
end
