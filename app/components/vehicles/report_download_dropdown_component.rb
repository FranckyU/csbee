module Vehicles
  class ReportDownloadDropdownComponent < ApplicationComponent
    def initialize(
      links: nil,
      label: "Reports",
      text_color: "white",
      bg_color: "indigo",
      icon: "download"
    )
      @links = links
      @label = label
      @text_color = text_color
      @bg_color = bg_color
      @icon = icon
    end

    def call
      render ::Generic::ButtonDropdownComponent.new(
        label: @label,
        links: (@links || default_links),
        label_color: @text_color,
        button_color: "#{@bg_color}-600",
        button_hover_color: "#{@bg_color}-700",
        icon: @icon
      )
    end

    private

    def default_links
      [
        [
          "Customers count by nationality",
          helpers.customers_by_nationality_reports_path(format: :csv)
        ],
        [
          "Avg. odometer reading by nationality",
          helpers.average_odometer_reading_by_nationality_reports_path(format: :csv)
        ]
      ]
    end
  end
end
