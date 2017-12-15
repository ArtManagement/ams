class CreateStaffs < ActiveRecord::Migration[5.0]
  def change
    create_table :staffs do |t|
      t.string :staff_no
      t.string :staff
      t.integer :company_id
      t.integer :sort
      t.boolean :usable
    end
  end
end
