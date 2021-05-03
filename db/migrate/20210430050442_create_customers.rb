class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers, force: true do |t|
      t.string :name
      t.string :email
      t.string :nationalty
      t.integer :vehicles_count

      t.references :country, null: true, foreign_key: true

      t.timestamps
    end
  end
end
