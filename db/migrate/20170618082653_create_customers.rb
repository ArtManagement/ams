class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.integer :customer_no
      t.integer :customer_class_id
      t.string :name
      t.string :kana
      t.string :abbreviation
      t.string :prefix
      t.string :zip_code
      t.integer :prefecture_id
      t.string :address1
      t.string :address2
      t.string :tel
      t.string :fax
      t.string :mobile
      t.string :email
      t.string :url
      t.string :rank
      t.boolean :a
      t.boolean :b
      t.boolean :c
      t.boolean :d
      t.boolean :e
      t.boolean :f
      t.boolean :g
      t.boolean :h
      t.string :note
      t.integer :company_id
      t.boolean :usable
      t.timestamps
    end
  end
end
