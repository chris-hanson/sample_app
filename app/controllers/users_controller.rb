class UsersController < ApplicationController
  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def show
    @user = User.find params[:id]
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
end
