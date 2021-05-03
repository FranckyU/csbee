class CustomerDecorator < Draper::Decorator
  delegate_all

  def displayable_country
    country&.name || nationality.presence || "n/a"
  end
end
