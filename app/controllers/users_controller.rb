class UsersController < ApplicationController

  before_action :authenticate_user, only: [:show, :destroy]

  def new
    @user = User.new
  end

  def create
    @user =User.new(user_params)
    if @user.save
      # Remember that the session is like a cookie.
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Sign up successful!"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    # First find the user that you want to update
    @user = User.find(params[:id])
    u_params = params.require(:user).permit(:first_name, :last_name, :email)

    if @user.update(u_params)
      redirect_to user_path(@user), notice: "User info successfully updated!"
    else
      flash[:alert] = "User info failed to update"
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    @user_posts = current_user.posts

    if @user == current_user
      render
    else
      redirect_to posts_path
    end
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    user_old_password = params[:user][:old_password]
    user_new_password = params.require(:user).permit(:password,:password_confirmation)
    if @user.authenticate(user_old_password)
      @user.update(user_new_password)
      redirect_to edit_user_path(@user), notice: "Password change successful!"
    else
      flash[:alert] = "Password change failed!"
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
