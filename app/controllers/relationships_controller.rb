class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_followed, only: :create
  before_action :find_followed_destroy, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def find_followed
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t ".follow_fail"
    redirect_to @user
  end

  def find_followed_destroy
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user

    flash[:danger] = t ".unfollow_fail"
    redirect_to @user
  end
end
