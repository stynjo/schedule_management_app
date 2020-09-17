class RemoveReservationDateFromReserves < ActiveRecord::Migration[6.0]
  def change
    remove_column :reserves, :reservation_date, :date
  end
end
