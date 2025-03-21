class CreateLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :number_of_pieces, null: false

      t.timestamps
    end
  end
end
