class CreateTrustReturns < ActiveRecord::Migration[5.0]
  def change
    create_table :trust_returns do |t|
      t.integer :trust_return_slip_id
      t.integer :trust_id
      t.text :note
      t.timestamps
    end
  end
end
