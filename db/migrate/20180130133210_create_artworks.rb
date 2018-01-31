class CreateArtworks < ActiveRecord::Migration[5.0]
  def change
    create_table :artworks do |t|
      t.string  :artwork_no
      t.integer :artist_id
      t.string  :title
      t.string  :title_eng
      t.integer :category_id
      t.integer :technique_id
      t.string  :technique_etc
      t.string  :technique_eng
      t.string  :material
      t.string  :material_eng
      t.integer :size_id
      t.integer :size_unit_id
      t.string  :size_etc
      t.string  :edition
      t.integer :edition_no
      t.integer :edition_limit
      t.string :production_year
      t.string  :raisonne
      t.integer :motif_id
      t.integer :format_id
      t.float   :height
      t.float   :width
      t.float   :depth
      t.float   :frame_height
      t.float   :frame_width
      t.float   :frame_depth
      t.string  :unit
      t.string  :frame_unit
      t.boolean :sign
      t.boolean :signature
      t.boolean :seal
      t.boolean :co_seal
      t.boolean :co_box
      t.boolean :certificate
      t.boolean :cloth_box
      t.boolean :insert_box
      t.boolean :cover_box
      t.boolean :yellow_bag
      t.integer :retail_price
      t.integer :wholesale_price
      t.integer :reference_price
      t.text    :condition
      t.text    :note
      t.string  :image1
      t.string  :image2
      t.string  :image3
      t.string  :image4
      t.timestamps
    end
  end
end
