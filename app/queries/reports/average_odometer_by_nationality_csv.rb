require "csv"

module Reports
  ## Query class to generate avg odometer by country report
  # Outputs CSV data
  class AverageOdometerByNationalityCSV < ApplicationQuery
    def execute
      csv
    end

    private

    def csv
      CSV.generate do |csv_file|
        csv_file << csv_header_row

        avg_odometer_by_country.each do |line|
          csv_file << [line.country_name, line.avg_odometer]
        end
      end
    end

    def csv_header_row
      ["Country", "AVG Odometer"]
    end

    def avg_odometer_by_country
      @avg_odometer_by_country ||=
        Vehicle
        .select("countries.name AS country_name, AVG(vehicles.odometer_reading) AS avg_odometer")
        .joins(owner: :country)
        .group(:country_id, "countries.name")
    end
  end
end
