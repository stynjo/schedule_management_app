class AddReserveNameToReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :reserves, :reserve_name, :string
  end
end
