class AddUniquenessIndexesForValidations < ActiveRecord::Migration[6.1]
  def change
    add_index :countries, :name, unique: true
    add_index :car_makes, :brand, unique: true
    add_index :car_models, [:name, :car_make_id], unique: true
  end
end
