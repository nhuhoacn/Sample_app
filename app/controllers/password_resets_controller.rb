class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)
  before_action :load_user, only: :create

  def new; end

  def create
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".send_email"
      redirect_to root_url
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".reset_pass"
      redirect_to @user
    else
      flash[:danger] = t ".not_reset_pass"
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t ".alert_user"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".expired"
    redirect_to new_password_reset_path
  end
end
