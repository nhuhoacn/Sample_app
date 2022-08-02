class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  protect_from_forgery with: :exception
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".not_log_in"
    redirect_to login_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to signup_path
  end
end
