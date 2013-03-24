class MicropostsController < ApplicationController
  before_filter :signed_in_user

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Your new post has been saved!"
      redirect_to root_path
    else
      render 'static_pages/home'
      flash[:error] = "Your post could not be saved"
    end
  end

  def destroy
  end
end
