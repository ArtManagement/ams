class CreateArtistClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_classes do |t|
      t.string :artist_class
      t.string :artist_class_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
