class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user?, only: :destroy

  def index
    @pagy, @users = pagy(User.all)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".new.success_message"
      redirect_to @user
    else
      flash.now[:danger] = t ".new.failure_message"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".edit.success_message"
      redirect_to @user
    else
      flash.now[:danger] = t ".edit.failure_message"
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".failed_delete_message"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".edit.authorization_message"
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t ".destroy.unauthorization_message"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    edirect_to path_root
  end

  def admin_user?
    return if current_user.admin?

    flash[:danger] = t ".destroy.unauthorization_message"
    redirect_to root_path
  end
end
