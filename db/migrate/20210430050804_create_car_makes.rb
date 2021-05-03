class CreateCarMakes < ActiveRecord::Migration[6.1]
  def change
    create_table :car_makes, force: true do |t|
      t.string :brand
      t.integer :car_models_count

      t.timestamps
    end
  end
end
