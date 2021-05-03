class AddImportResultColumnsToVehiclesImport < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles_imports, :failed_instances, :text
    add_column :vehicles_imports, :num_inserts, :integer, default: 0
  end
end
