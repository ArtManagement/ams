class CreateSaleCancels < ActiveRecord::Migration[5.0]
  def change
    create_table :sale_cancels do |t|
      t.integer :sale_cancel_slip_id
      t.integer :sale_id
      t.text :note
      t.timestamps
    end
  end
end
