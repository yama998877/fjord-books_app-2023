# frozen_string_literal: true

module UsersHelper
  def current_user_name(user)
    [user.name, user.email].find(&:present?)
  end

  def name_or_email(resouce)
    if resouce.user.name.strip.empty?
      resouce.user.email
    else
      resouce.user.name
    end
  end
end
