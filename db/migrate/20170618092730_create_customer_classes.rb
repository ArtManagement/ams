class CreateCustomerClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :customer_classes do |t|
      t.string :customer_class
      t.string :customer_class_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
