# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def date_to_west_hours(time)
    time.strftime('%H:%M %p')
  end
end
