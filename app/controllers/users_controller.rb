class UsersController < ApplicationController
  skip_before_action :verified_user, only: [:new, :create]

  def new
    if current_user.role_name != "Admin"
      redirect_to user_path(current_user)
    else
      @user = User.new
      @roles = Role.all
    end
  end

  def create
    user = User.create(user_params)
    redirect_to user_path(user)
  end

  def index
    if current_user.role_name != "Admin"
      redirect_to user_path(current_user)
    else
      @users = User.all
    end
  end

  def show
    if current_user.role_name != "Admin" && current_user.id != params[:id].to_i
      redirect_to user_path(current_user)
    else
      @user = User.find(params[:id])
    end
  end

  def edit
    # binding.pry
    @user = User.find(params[:id])
    @roles = Role.all
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :role_id,
      :email,
      :password,
      :password_confirmation
    )
  end

end