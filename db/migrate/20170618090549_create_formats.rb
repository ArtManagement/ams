class CreateFormats < ActiveRecord::Migration[5.0]
  def change
    create_table :formats do |t|
      t.string :format
      t.string :format_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
