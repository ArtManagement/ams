class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.integer :artist_class_id
      t.string :name
      t.string :kana
      t.string :name_eng
      t.datetime :birth_date
      t.datetime :death_date
      t.string :real_name
      t.string :real_name_eng
      t.string :birth_place
      t.string :birth_place_eng
      t.integer :nationality_id
      t.string :affiliation
      t.string :affiliation_eng
      t.text :brief_history
      t.text :brief_history_eng
      t.text :note
      t.text :note_eng
    end
  end
end
