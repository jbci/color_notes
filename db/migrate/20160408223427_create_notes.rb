class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :board, index: true, foreign_key: true
      t.string :text
      t.integer :x
      t.integer :y
      t.string :color

      t.timestamps null: false
    end
  end
end
