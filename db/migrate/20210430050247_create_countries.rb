class CreateCountries < ActiveRecord::Migration[6.1]
  def change
    create_table :countries, force: true do |t|
      t.string :name
      t.integer :customers_count

      t.timestamps
    end
  end
end
