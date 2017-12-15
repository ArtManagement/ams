class CreateSizeUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :size_units do |t|
      t.string :size_unit
      t.string :size_unit_eng
    end
  end
end
