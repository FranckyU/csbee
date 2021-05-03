class CreateCarModels < ActiveRecord::Migration[6.1]
  def change
    create_table :car_models, force: true do |t|
      t.string :name
      t.integer :vehicles_count

      t.references :car_make, null: false, foreign_key: true

      t.timestamps
    end
  end
end
