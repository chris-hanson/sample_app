class SessionsController < ApplicationController
  
  def new
    redirect_to root_path if signed_in?
  end

  def create
    user = User.find_by_email(params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
      flash[:success] = "You have been sucessfully signed in!"
    else
      flash.now[:error] = "Invalid email/ password combination"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
    flash[:success] = "You have sucessfully signed out"
  end
end
