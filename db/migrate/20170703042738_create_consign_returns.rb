class CreateConsignReturns < ActiveRecord::Migration[5.0]
  def change
    create_table :consign_returns do |t|
      t.integer :consign_return_slip_id
      t.integer :consign_id
      t.text :note
      t.timestamps
    end
  end
end
