class SessionsController < ApplicationController
  before_action :find_by_email, only: :create

  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      check_activated_user
    else
      flash.now[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def find_by_email
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to signup_path
  end

  def check_activated_user
    if @user.activated?
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t ".account_not_activated"
      redirect_to root_path
    end
  end
end
