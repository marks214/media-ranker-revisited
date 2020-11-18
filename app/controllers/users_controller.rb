class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :delete]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: 'github')#params[:provider])

    if user
      #user exists
      flash[:status] = :success
      flash[:result_text] = "Existing user #{user.username} is logged in."
    else
      #user doesn't exist yet
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{user.username}"
      else
        flash[:error] = "Could not create user account #{user.errors.messages}"
      end
    end

    session[:user_id] = user.id
    session[:username] = user.username
    redirect_to root_path
    return
  end

  def destroy
    if session[:user_id]
      session[:user_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out"
      redirect_to root_path
      return
    else
      flash[:error] = "Must log in first!"
      redirect_to root_path
    end

  end
end
