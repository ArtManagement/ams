class CreateNationalities < ActiveRecord::Migration[5.0]
  def change
    create_table :nationalities do |t|
      t.string :nationality
      t.string :nationality_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
