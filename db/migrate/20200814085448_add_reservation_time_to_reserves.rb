class AddReservationTimeToReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :reserves, :resavation_time, :datetime
  end
end
