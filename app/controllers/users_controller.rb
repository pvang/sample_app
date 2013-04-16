class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new # an @user variable to the new action
  end

  def create
    @user = User.new(params[:user])
    if @user.save
       sign_in @user # signing in the user upon sign up
       flash[:success] = "Welcome to the Sample App!"
       redirect_to @user # action that handles signup success (redirecting)
    else
      render 'new' # action that handles signup unsuccess
    end
  end

end