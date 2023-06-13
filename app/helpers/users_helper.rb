module UsersHelper
  def display_name(user)
    if user.profile
      user.profile.username
    else
      user.email.split("@").first.capitalize
    end
  end

  def display_date(date)
    zone = ActiveSupport::TimeZone.new(current_user.get_time_zone)
    date = date.in_time_zone(zone)
    if date.today?
      date.strftime("%l:%M %P") #"today"
    elsif date.yesterday?
      "yesterday"
    else
      date.strftime("%D")
    end
  end
end
