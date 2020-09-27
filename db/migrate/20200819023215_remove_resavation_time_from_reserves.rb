class RemoveResavationTimeFromReserves < ActiveRecord::Migration[6.0]
  def change
    remove_column :reserves, :resavation_time, :datetime
  end
end
