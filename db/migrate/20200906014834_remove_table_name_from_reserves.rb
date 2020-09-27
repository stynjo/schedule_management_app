class RemoveTableNameFromReserves < ActiveRecord::Migration[6.0]
  def change
    remove_column :reserves, :table_name, :string
    remove_column :reserves, :string, :string
  end
end
