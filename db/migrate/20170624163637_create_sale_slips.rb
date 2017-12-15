class CreateSaleSlips < ActiveRecord::Migration[5.0]
  def change
    create_table :sale_slips do |t|
      t.string :slip_no
      t.datetime :date
      t.integer :customer_id
      t.datetime :scheduled_date
      t.integer :tax_class_id
      t.float :tax_rate
      t.integer :staff_id
      t.text :note
      t.integer :company_id
      t.integer :user_id
      t.string :sort1
      t.string :sort2
      t.string :sort3
      t.timestamps
    end
  end
end
