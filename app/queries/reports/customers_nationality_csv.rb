require "csv"

module Reports
  ## Query class to generate customers count by country report
  # Outputs CSV data
  class CustomersNationalityCSV < ApplicationQuery
    def execute
      csv
    end

    private

    def csv
      CSV.generate do |csv_file|
        csv_file << csv_header_row

        customers_by_country.each do |line|
          csv_file << [line.country_name, line.customers_count]
        end
      end
    end

    def csv_header_row
      %w(Country Customers)
    end

    def customers_by_country
      @customers_by_country ||=
        Customer
        .select("countries.name AS country_name, COUNT(customers.id) AS customers_count")
        .joins(:country)
        .group(:country_id, "countries.name")
    end
  end
end
