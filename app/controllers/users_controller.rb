class UsersController < ApplicationController
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
    @user = User.find(params[:id])
  end  #edit


def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end  #if else
  end  #update


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end #user_params

  end #private
