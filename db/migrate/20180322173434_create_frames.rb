class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.integer :frame_slip_id
      t.integer :artwork_id
      t.integer :frame_class_id
      t.integer :price
      t.integer :specification
      t.text :note
      t.timestamps
    end
  end
end
