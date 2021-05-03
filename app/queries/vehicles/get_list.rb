module Vehicles
  ## Query class to list vehicles from the database
  # accepts ransack query parameters
  class GetList < ApplicationQuery
    hash :q, default: {}, strip: false

    def execute
      OpenStruct.new(
        query: ransack,
        collection: collection
      )
    end

    private

    def ransack
      @ransack ||= Vehicle.ransack(q)
    end

    def collection
      ransack
        .result
        .order(created_at: :desc)
        .includes(:owner, car_model: :car_make)
    end
  end
end
