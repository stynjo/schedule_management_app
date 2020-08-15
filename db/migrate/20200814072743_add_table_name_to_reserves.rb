class AddTableNameToReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :reserves, :table_name, :string
  end
end
