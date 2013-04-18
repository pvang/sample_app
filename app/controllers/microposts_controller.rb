# adding authentication to the Microposts controller actions

class MicropostsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create # microposts controller create action
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = [] # an (empty) @feed_items instance variable
      render 'static_pages/home'
    end
  end

  def destroy # the microposts controller destroy action
    @micropost.destroy
    redirect_to root_url
  end

  private

    def correct_user # ensures that we find only microposts belonging to the current user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end

end