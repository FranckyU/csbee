class AddCustomerEmailUniquenessIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :customers, :email, unique: true
  end
end
