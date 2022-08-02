class FollowersController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t ".title_show_followers"
    @pagy, @users = pagy @user.followers
    render :show_follow
  end
end
