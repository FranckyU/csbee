class Vehicle < ApplicationRecord
  ## SCHEMA
  # t.string :year
  # t.string :chassis_number
  # t.string :color
  # t.date :registration_date
  # t.integer :odometer_reading
  # t.string :cached_car_model
  # t.references :customer, null: false, foreign_key: true
  # t.references :car_model, null: true, foreign_key: true
  # t.timestamps

  belongs_to :car_model,
             inverse_of: :vehicles,
             optional: true

  belongs_to :owner,
             class_name: "Customer",
             foreign_key: "customer_id",
             inverse_of: :vehicles,
             counter_cache: true

  validates :year, presence: true
  validates :chassis_number, presence: true, uniqueness: true
  validates :owner, presence: true
end
