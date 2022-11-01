class SessionsController < ApplicationController
  def create
    @user = (
      User.find_by(username: session_params[:unameOrEmail]) # try to find by username first
    ) || (
      User.find_by(email: session_params[:unameOrEmail]) # try email next
    )

    puts @user.to_json
  
    if @user && @user.authenticate(session_params[:password])
      login!
      render json: {
        logged_in: true,
        user: @user
      }
    else
      render json: { 
        status: 401,
        errors: ['no such user', 'verify credentials and try again or signup']
      }, :status => 401
    end
  end

  def is_logged_in?
    if logged_in? && current_user
      render json: {
        logged_in: true,
        user: current_user
      }
    else
      render json: {
        logged_in: false,
        message: 'no such user'
      }
    end
  end

  def destroy
    logout!
    render json: {
      status: 200,
      logged_out: true
    }
  end

  private

  def session_params
    params.require(:user).permit(:unameOrEmail, :password, :session)
  end
end