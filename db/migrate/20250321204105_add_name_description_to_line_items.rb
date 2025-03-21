class AddNameDescriptionToLineItems < ActiveRecord::Migration[8.0]
  def change
    add_column :line_items, :name, :string
    add_column :line_items, :description, :text
  end
end
