class Country < ApplicationRecord
  ## SCHEMA
  # t.string :name
  # t.integer :customers_count
  # t.timestamps

  has_many :customers,
           dependent: :nullify,
           inverse_of: :country

  validates :name,
            presence: true,
            uniqueness: true
end
