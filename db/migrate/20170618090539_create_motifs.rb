class CreateMotifs < ActiveRecord::Migration[5.0]
  def change
    create_table :motifs do |t|
      t.string :motif
      t.string :motif_eng
      t.integer :sort
      t.boolean :usable
    end
  end
end
