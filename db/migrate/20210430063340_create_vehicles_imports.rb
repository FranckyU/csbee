class CreateVehiclesImports < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles_imports, force: true do |t|
      t.timestamps
    end
  end
end
