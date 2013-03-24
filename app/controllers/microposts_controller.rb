class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Your new post has been saved!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
      flash[:error] = "Your post could not be saved"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if Micropost.nil?
    end
end
