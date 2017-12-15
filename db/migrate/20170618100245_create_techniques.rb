class CreateTechniques < ActiveRecord::Migration[5.0]
  def change
    create_table :techniques do |t|
      t.integer :category_id
      t.string :technique
      t.string :technique_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
