class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer :artist_id
      t.string  :title
      t.integer :category_id
      t.integer :technique_id
      t.string  :technique_etc
      t.integer :size_id
      t.integer :size_unit_id
      t.string  :size_etc
      t.string  :image1
      t.string  :image2
      t.string  :image3
      t.string  :image4
      t.string  :image5
      t.string  :image6
      t.timestamps
    end
  end
end
