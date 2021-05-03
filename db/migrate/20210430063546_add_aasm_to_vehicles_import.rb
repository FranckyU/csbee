class AddAasmToVehiclesImport < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles_imports, :state, :string, null: false, default: VehiclesImport::DEFAULT_STATE
  end
end
