class CreateReserves < ActiveRecord::Migration[6.0]
  def change
    create_table :reserves do |t|
      t.date :reservation_date
      t.integer :number_of_people

      t.timestamps
    end
  end
end
