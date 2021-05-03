class VehiclesController < ApplicationController
  before_action :build_vehicles_import, only: [:import, :process_import]
  before_action :load_vehicle, only: [:destroy]

  def index
    vehicles_list =
      Vehicles::GetList
      .run(q: params.fetch(:q, {}).permit!.to_h)
      .result

    @q = vehicles_list.query
    @pagination, @vehicles = pagy(vehicles_list.collection)
  end

  def import
    render(layout: false)
  end

  def import_template
    send_file(
      Rails.root.join("public/templates/vehicles-import.csv"),
      type: "text/csv",
      filename: "csbee-import-template-#{Time.zone.now.to_i}.csv"
    )
  end

  def process_import
    @vehicles_import.update(vehicle_import_params)

    if @vehicles_import.persisted?
      VehiclesImportJob.perform_later(@vehicles_import.id)

      redirect_back fallback_location: vehicles_path, status: :see_other
    else
      render :import, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle&.destroy

    redirect_back fallback_location: vehicles_path, status: :see_other
  end

  protected

  def build_vehicles_import
    @vehicles_import = VehiclesImport.new
  end

  def load_vehicle
    @vehicle = begin
      Vehicle.find(params[:id])
    rescue StandardError
      nil
    end
  end

  def vehicle_import_params
    params
      .fetch(:vehicles_import, {})
      .permit(:csv_file)
  end
end
