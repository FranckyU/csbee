module Generic
  class ButtonDropdownComponent < ApplicationComponent
    # rubocop:disable Metrics/ParameterLists
    def initialize(
      label:,
      links:,
      label_color: "gray-700",
      button_color: "white",
      button_hover_color: "gray-50",
      icon: nil
    )
      @label = label
      @links = links
      @label_color = label_color
      @button_color = button_color
      @button_hover_color = button_hover_color
      @icon = icon
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
