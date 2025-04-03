# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def date_to_west_hours(time)
    time.strftime('%H:%M %p')
  end

  def extended_date(time)
    time.strftime('%b %eth at %-I:%M:%S %p')
  end

  def day_and_month(time)
    day = time.day
    suffix = case day % 10
             when 1 then (day == 11 ? 'th' : 'st')
             when 2 then (day == 12 ? 'th' : 'nd')
             when 3 then (day == 13 ? 'th' : 'rd')
             else 'th'
             end

    time.strftime("%A, %B #{day}#{suffix}")
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
