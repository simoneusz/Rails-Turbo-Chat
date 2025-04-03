# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def date_to_west_hours(time)
    time.strftime('%H:%M %p')
  end

  def extended_date(time)
    time.strftime('%b %eth at %-I:%M:%S %p')
  end

  def user_css_status(status)
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    else
      'bg-dark'
    end
  end
end
