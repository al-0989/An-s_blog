class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    # This checks to make sure there is a user matching that email and that
    # the password they have entered is correct. This makes use of the built in
    # .authenticate method that is supplied by nas_secure_password.
    if @user && @user.authenticate(params[:password])
      # if that matches then we set the session id to be that of the current user.
      # ie: we sign the user in. This can be refactored by creating a sign_in
      # method in the application controller.
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Log in successful!"
    else
      flash[:alert] = "Incorrect email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end
end
