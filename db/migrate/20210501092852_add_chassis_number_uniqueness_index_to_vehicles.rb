class AddChassisNumberUniquenessIndexToVehicles < ActiveRecord::Migration[6.1]
  def change
    add_index :vehicles, :chassis_number, unique: true
  end
end
