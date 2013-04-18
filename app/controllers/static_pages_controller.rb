class StaticPagesController < ApplicationController

  def home
  	# @micropost = current_user.microposts.build if signed_in? # a micropost instance variable to the home action
    if signed_in? # adding a feed instance variable to the home action
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end