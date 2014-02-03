class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver
      sign_in @user
      flash[:success] = "Welcome to the Fire&RescueGame!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def forgot_password
    @user = User.new
  end
  
  def send_password_reset_instructions
    name_or_email = params[:user][:name]
  
    if name_or_email.rindex('@')
      user = User.find_by_email(name_or_email)
    else
      user = User.find_by_name(name_or_email)
    end
  
    if user
      user.send_password_reset if user
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      @user = User.new
      flash[:error] = 'Name/Email not found.'
      redirect_to forgot_password_path
    end
  end

  def password_reset
    @user = User.find_by_password_reset_token(params[:id])
    if @user.nil?
      redirect_to root_url, :alert => "You have not requested a password reset."
      return
    end
  end
    
  def new_password
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to password_reset_path(:id => @user.password_reset_token), :alert => "Password reset has expired."
    elsif @user.update_attributes(user_params)
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render 'password_reset'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
