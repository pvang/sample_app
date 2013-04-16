class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase) # user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:password]) # sign user in and redirect to the show page # if user && user.authenticate(params[:session][:password])
      session[:user] = user.id # added when refactored the signin form to use form_tag in place of form_for
      sign_in user
      redirect_back_or user # redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination' # error message
      render 'new' # a minimalist create action for the Sessions controller which does nothing but render the new view
    end
  end

  def destroy # destroying a session (user signout)
    sign_out # sign out
    redirect_to root_url # return to home page
  end

end