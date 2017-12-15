class CreatePurchaseCancels < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_cancels do |t|
      t.integer :purchase_cancel_slip_id
      t.integer :purchase_id
      t.text :note
      t.timestamps
    end
  end
end
