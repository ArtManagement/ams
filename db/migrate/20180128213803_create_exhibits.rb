class CreateExhibits < ActiveRecord::Migration[5.0]
  def change
    create_table :exhibits do |t|
      t.integer :exhibit_slip_id
      t.integer :artwork_id
      t.integer :price
      t.text :note
      t.timestamps
    end
  end
end
