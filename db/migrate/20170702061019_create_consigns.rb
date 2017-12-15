class CreateConsigns < ActiveRecord::Migration[5.0]
  def change
    create_table :consigns do |t|
      t.integer :consign_slip_id
      t.integer :artwork_id
      t.integer :price
      t.text :note
      t.timestamps
    end
  end
end
