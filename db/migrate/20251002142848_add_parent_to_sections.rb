class AddParentToSections < ActiveRecord::Migration[7.2]
  def change
    add_column :sections, :parent_id, :integer
  end
end
