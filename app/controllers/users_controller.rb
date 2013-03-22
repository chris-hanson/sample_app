class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find params[:id]
  end

  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      redirect_to root_path
    else
      @user = User.new params[:user]
      
      if @user.save
        sign_in @user
        flash[:success] = "Welcome, your account hsa been created!"
        redirect_to @user
      else
        render 'new'
      end
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes(params[:user])
      flash[:success] = "Your profile has been udpated!"
      sign_in @user
      redirect_to @user
    else
      flash[:error] = "Your profile could not be updated"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted"
    redirect_to users_path
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in." 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
      
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
