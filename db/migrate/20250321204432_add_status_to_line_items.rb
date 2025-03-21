class AddStatusToLineItems < ActiveRecord::Migration[8.0]
  def change
    add_column :line_items, :status, :integer, default: 0
  end
end
