class CarModel < ApplicationRecord
  ## SCHEMA
  # t.string :name
  # t.integer :vehicles_count
  # t.references :car_make, null: false, foreign_key: true
  # t.timestamps

  belongs_to :car_make,
             inverse_of: :car_models,
             counter_cache: true

  has_many :vehicles,
           inverse_of: :car_model,
           dependent: :nullify

  validates :name,
            presence: true,
            uniqueness: { scope: :car_make }

  validates :car_make, presence: true
end
