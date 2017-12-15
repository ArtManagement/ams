class CreateSorts < ActiveRecord::Migration[5.0]
  def change
    create_table :sorts do |t|
      t.string :sort_key
      t.string :sort
    end
  end
end
