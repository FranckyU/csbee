require "csv"

# rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
module Vehicles
  ## Bulk import vehicles efficiently using AR import
  # Duplicates are updated
  class Import < ActiveInteraction::Base
    record :vehicles_import

    def execute
      ActiveRecord::Base.transaction do
        vehicles_import.reset_counters!
        vehicles_import.start!
        import_csv_data
        vehicles_import.complete!
      end

      [:ok, vehicles_import]
    rescue StandardError => e
      vehicles_import.mark_failure!

      [:error, e, vehicles_import]
    end

    private

    def import_csv_data
      import_batch = []

      csv_table.each do |csv_row|
        customer = customer_from_csv_row(csv_row)

        if customer.persisted?
          vehicle = vehicle_from_csv_row(csv_row, customer)

          if vehicle.valid?
            import_batch << vehicle unless vehicle.persisted?
          else
            vehicles_import.failed_instances << [:invalid_vehicle, csv_row.to_h]
          end
        else
          vehicles_import.failed_instances << [:invalid_customer, csv_row.to_h]
        end
      end

      result = Vehicle.import(import_batch)

      if result.failed_instances.any?
        failed_rows =
          result
          .failed_instances
          .map { |record| [:invalid_vehicle, record] }

        vehicles_import.update(
          failed_instances: vehicles_import.failed_instances + failed_rows
        )
      end

      vehicles_import.update(num_inserts: result.ids.length)

      link_to_car_models(result.ids)
    end

    def csv_table
      @csv_table ||=
        CSV.parse(
          vehicles_import.csv_file.download,
          headers: true,
          converters: csv_row_converter,
          encoding: "UTF-8"
        )
    end

    def customer_from_csv_row(csv_row)
      customer_by_email(csv_row) || new_customer_from_csv_row(csv_row)
    end

    def customer_by_email(csv_row)
      customer =
        Customer
        .find_by(email: csv_row["Email"])

      return unless customer
      return customer if customer.name == customer_name_from_csv_row(csv_row)
    end

    def customer_name_from_csv_row(csv_row)
      country = country_from_csv_row(csv_row)

      return csv_row["Name"] if country

      "#{csv_row['Name']} #{csv_row['Nationality']}"
    end

    def new_customer_from_csv_row(csv_row)
      country = country_from_csv_row(csv_row)

      if country
        country.customers.create(
          name: csv_row["Name"],
          email: csv_row["Email"],
          nationality: country.name
        )
      else
        Customer.create(
          name: customer_name_from_csv_row(csv_row),
          email: csv_row["Email"]
        )
      end
    end

    def vehicle_from_csv_row(csv_row, customer)
      existing_vehicle = Vehicle.find_by(
        chassis_number: csv_row["ChassisNumber"]
      )

      return Vehicle.new if existing_vehicle && existing_vehicle.owner != customer

      if existing_vehicle&.owner == customer
        existing_vehicle.update(
          year: csv_row["Year"],
          color: csv_row["Color"].downcase,
          registration_date: csv_row["RegistrationDate"],
          odometer_reading: csv_row["OdometerReading"],
          cached_car_model: csv_row["Model"]
        )

        return existing_vehicle
      end

      customer.vehicles.build(
        year: csv_row["Year"],
        chassis_number: csv_row["ChassisNumber"],
        color: csv_row["Color"].downcase,
        registration_date: csv_row["RegistrationDate"],
        odometer_reading: csv_row["OdometerReading"],
        cached_car_model: csv_row["Model"]
      )
    end

    def country_from_csv_row(csv_row)
      Country.where("name ILIKE ?", "%#{csv_row['Nationality']}%").first
    end

    def csv_row_converter
      # Can also use CSV::Converters[:symbol]
      # @csv_row_converter ||= lambda do |value|
      #  case value.to_s
      #  when /\d+\/\d+\/\d+/ then Time.zone.parse(value.to_s.strip)
      #  when /\d+/ then value.to_i
      #  else value.strip
      #  end
      # end

      ->(value) { value.to_s.strip }
    end

    def link_to_car_models(vehicle_ids)
      Vehicle.where(id: vehicle_ids).each do |vehicle|
        link_to_car_model(vehicle)
      end
    end

    def all_car_brands
      @all_car_brands ||= CarMake.all.load
    end

    def link_to_car_model(vehicle)
      return if vehicle.cached_car_model.blank?

      car_make = all_car_brands.detect do |car_brand|
        vehicle.cached_car_model =~ /#{car_brand.brand}/i
      end

      return unless car_make

      car_model_name =
        vehicle
        .cached_car_model
        .gsub(/#{car_make.brand}/i, "")
        .strip

      # TODO: maybe we can associate directly vehicle <-> car_make ?
      return if car_model_name.blank?

      # TODO: sometimes the wrong car make is specified for the model
      # should we link to the right brand?
      # actually out of the scope of this work
      # we assume the make/model is always right from the CSV

      car_model = car_make.car_models.find_or_create_by(name: car_model_name)
      car_model.vehicles << vehicle
    end
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
