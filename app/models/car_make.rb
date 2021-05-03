class CarMake < ApplicationRecord
  ## SCHEMA
  # t.string :brand
  # t.integer :car_models_count
  # t.timestamps

  has_many :car_models,
           inverse_of: :car_make,
           dependent: :nullify

  validates :brand,
            presence: true,
            uniqueness: true
end
