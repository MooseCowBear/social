module UsersHelper
  def display_name(user)
    if user.profile
      user.profile.username
    else
      user.email
    end
  end
end
