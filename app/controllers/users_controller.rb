class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.order_by_id, page: params[:page],
      items: Settings.user.pagy_page
  end

  def show
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_mail_activate
      flash[:info] = t ".mail_notice"
      redirect_to root_path
    else
      flash.now[:danger] = t ".users_unsuccess"
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_delete_fail"
    end
    redirect_to users_path
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_user"
      redirect_to @user
    else
      flash[:danger] = t ".update_false"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_ATTRIBUTES
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".danger"
    redirect_to login_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t ".incorrect_user"
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t ".incorrect_admin"
    redirect_to root_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to signup_path
  end
end
