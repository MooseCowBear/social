module UsersHelper
  def display_name(user)
    if user.profile
      user.profile.username
    else
      user.email
    end
  end

  def display_date(date)
    zone = ActiveSupport::TimeZone.new(current_user.get_time_zone)
    date = date.in_time_zone(zone)
    if date.today?
      "today"
    elsif date.yesterday?
      "yesterday"
    else
      date.strftime("%D")
    end
  end
end
