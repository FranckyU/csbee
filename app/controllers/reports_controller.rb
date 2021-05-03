class ReportsController < ApplicationController
  def customers_by_nationality
    send_data(
      Reports::CustomersNationalityCSV.run!,
      type: "text/csv",
      filename: "csbee-customers-by-nationality-#{Time.zone.now.to_i}.csv"
    )
  end

  def average_odometer_reading_by_nationality
    send_data(
      Reports::AverageOdometerByNationalityCSV.run!,
      type: "text/csv",
      filename: "csbee-average-odometer.by-nationality-#{Time.zone.now.to_i}.csv"
    )
  end
end
