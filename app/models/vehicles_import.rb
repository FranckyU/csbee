class VehiclesImport < ApplicationRecord
  ## SCHEMA
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false
  # t.string "state", default: "pending", null: false
  # t.text "failed_instances"
  # t.integer "num_inserts", default: 0

  include AASM

  DEFAULT_STATE = :pending

  aasm(column: "state") do
    state :pending, initial: true
    state :processing, :failed, :completed

    event(:start) { transitions from: :pending, to: :processing }
    event(:mark_failure) { transitions from: :processing, to: :failed }
    event(:complete) { transitions from: :processing, to: :completed }

    event(:restart) { transitions from: [:completed, :failed], to: :pending }
  end

  serialize :failed_instances, Array

  has_one_attached :csv_file

  validates :csv_file, attached: true, content_type: ["text/csv"]

  def process!
    Vehicles::Import.run(vehicles_import: self)
  end

  def reprocess!
    restart!
    process!
  end

  def reset_counters!
    update(num_inserts: 0, failed_instances: [])
  end
end
