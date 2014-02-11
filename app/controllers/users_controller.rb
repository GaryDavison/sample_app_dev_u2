class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_filter :signed_in_user_filter, only: [:new, :create]


  def index
    @users = User.paginate(page: params[:page])
  end #index


  def show
    @user = User.find(params[:id])
  end #show

  def new
    @user = User.new
  end  #new

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
     else
      render 'new'
    end  # if @user.save
  end  #create


  def edit
  end  #edit


  def update
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end  #if else
  end  #update

  def destroy
    user = User.find(params[:id])
    unless current_user?(user)
      user.destroy
      flash[:success] = "User deleted."
    else
      flash[:error] =  "Admin cannot destroy self"
    end
    redirect_to users_url
  end  #destroy



  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end #user_params

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end # unless signed in
    end  #signed in user

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end #correct user

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end #admin

  def signed_in_user_filter
    if signed_in?
        redirect_to root_path, notice: "Already logged in"
    end
  end  #signed in user filter

  end #private
#end #class
