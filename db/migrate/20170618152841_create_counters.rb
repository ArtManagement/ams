class CreateCounters < ActiveRecord::Migration[5.0]
  def change
    create_table :counters do |t|
      t.integer :company_id
      t.integer :year
      t.integer :artwork
      t.integer :purchase
      t.integer :sale
      t.integer :trust
      t.integer :consign
      t.integer :payment
      t.integer :deposit
      t.integer :frame
      t.integer :exhibit
    end
  end
end
