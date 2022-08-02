class FollowingController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t ".title_show_following"
    @pagy, @users = pagy @user.following
    render :show_follow
  end
end
