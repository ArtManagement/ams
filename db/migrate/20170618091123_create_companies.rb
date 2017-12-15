class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :company
      t.string :company_eng
      t.string :position
      t.string :position_eng
      t.string :president
      t.string :president_eng
      t.string :zip_code
      t.integer :prefecture_id
      t.string :address1
      t.string :address2
      t.string :address1_eng
      t.string :address2_eng
      t.string :tel
      t.string :fax
      t.string :email
      t.string :url
      t.integer :tax_class_id
      t.float :tax_rate
      t.integer :account_closing_month
      t.boolean :usable
    end
  end
end
