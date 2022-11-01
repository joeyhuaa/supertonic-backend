class UsersController < ApplicationController
  def index
    @users = User.all
    if @users
      render json: {
        users: @users
      }
    else
      render json: {
        status: 500,
        errors: ['no users found']
      }
    end
  end

  def show
    @user = User.find(params[:id])
    if @user
      render json: {
        user: @user
      }
    else
      render json: {
        status: 500,
        errors: ['user not found']
      }
    end
  end
    
  def create
    @user = User.new(user_params)

    puts 'SIGN UP'
    puts user_params

    @user.theme = 'nocturne'

    if @user.save
      login!
      render json: {
        status: :created,
        user: @user
      }
    else 
      render json: {
        status: 500,
        errors: @user.errors.full_messages
      }, :status => 500
    end
  end

  def theme
    #! render :json => {theme: current_user.theme}
    render :json => {theme: 'nocturne'}
  end

  def change_theme
    # @user = current_user
    @user = User.find(params[:userId])
    @user.theme = params[:theme]
    @user.save
    # render :json => {theme: @user.theme}
    render :json => @user
  end

  private
    
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end