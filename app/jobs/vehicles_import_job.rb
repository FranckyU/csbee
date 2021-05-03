class VehiclesImportJob < ApplicationJob
  queue_as :default

  def perform(import_record_id)
    VehiclesImport.find(import_record_id).process!
  end
end
