class Customer < ApplicationRecord
  ## SCHEMA
  # t.string :name
  # t.string :email
  # t.string :nationality
  # t.integer :vehicles_count
  # t.references :country, null: true, foreign_key: true
  # t.timestamps

  belongs_to :country,
             inverse_of: :customers,
             optional: true,
             counter_cache: true

  has_many :vehicles,
           inverse_of: :owner,
           dependent: :destroy

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
