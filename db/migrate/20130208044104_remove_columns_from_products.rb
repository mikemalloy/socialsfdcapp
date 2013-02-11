class RemoveColumnsFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :name
    remove_column :products, :product
  end

  def down
  end
end
