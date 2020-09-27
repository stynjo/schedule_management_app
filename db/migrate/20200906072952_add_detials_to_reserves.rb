class AddDetialsToReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :reserves, :reservation_start_time, :datetime
    add_column :reserves, :reservation_end_time, :datetime
  end
end
