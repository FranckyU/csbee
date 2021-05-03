class ChangeVehiclesOdometerColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column :vehicles, :odometer_reading, "integer USING odometer_reading::integer"
  end
end
