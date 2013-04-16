class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy] # a signed_in_user before filter (which arranges for a particular method to be called before the given actions)
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy # before filter restricting the destroy action to admins

  def index # user index action
    # @users = User.all
    @users = User.paginate(page: params[:page]) # paginating the users in the index action
  end

  def show # user show action
    @user = User.find(params[:id])
  end

  def new # user new action
    @user = User.new # an @user variable to the new action
  end

  def destroy # user destroy action
    User.find(params[:id]).destroy # uses method chaining to combine the find and destroy into one line
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def create # user create action
    @user = User.new(params[:user])
    if @user.save
       sign_in @user # signing in the user upon sign up
       flash[:success] = "Welcome to the Sample App!"
       redirect_to @user # action that handles signup success (redirecting)
    else
      render 'new' # action that handles signup unsuccess
    end
  end

  def edit # user edit action
    # @user = User.find(params[:id])
  end

  def update # user update action
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user # action that handles update success
      redirect_to @user
    else
      render 'edit' # action that handles update unsuccess
    end
  end

  private

    def signed_in_user # to require users to be signed in, we define a signed_in_user method and invoke it using before_filter
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user # to require correct user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user # before filter restricting the destroy action to admins
      redirect_to(root_path) unless current_user.admin?
    end

end