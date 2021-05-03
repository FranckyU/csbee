class LoadInfrastructureData < ActiveRecord::Migration[6.1]
  def up
    Rake::Task["seed:load"].invoke
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
