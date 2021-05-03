class RenameCustomersNationaltyColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :customers, :nationalty, :nationality
  end
end
