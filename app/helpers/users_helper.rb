module UsersHelper
  def gravatar_for user, _options = {size: Settings.helpers.users_size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def follow_form
    current_user.active_relationships.build
  end

  def unfollow_form
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
