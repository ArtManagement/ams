class CreateTrusts < ActiveRecord::Migration[5.0]
  def change
    create_table :trusts do |t|
      t.integer :trust_slip_id
      t.integer :artwork_id
      t.integer :price
      t.text :note
      t.timestamps
    end
  end
end
