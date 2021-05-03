class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles, force: true do |t|
      t.string :year
      t.string :chassis_number
      t.string :color
      t.date :registration_date
      t.string :odometer_reading
      t.string :cached_car_model

      t.references :customer, null: false, foreign_key: true
      t.references :car_model, null: true, foreign_key: true

      t.timestamps
    end
  end
end
