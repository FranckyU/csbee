module Vehicles
  class RowComponent < ApplicationComponent
    def initialize(vehicle:)
      @vehicle = vehicle
    end
  end
end
