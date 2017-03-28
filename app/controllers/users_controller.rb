class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :collect_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    @user.region = "No data"
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Create #{@user.name} user and log in"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'アカウント情報を更新しました'
    else
      render 'edit'
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :region)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def collect_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "You tried to access different user acount"
      redirect_to @user
    end
  end  
end
