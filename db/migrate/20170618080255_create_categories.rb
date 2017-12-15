class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :category
      t.string :category_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
