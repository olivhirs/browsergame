class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmation == true
        sign_in user
        redirect_back_or user
      else
        flash.now[:error] = 'Email address is not confirmed.'
        render 'new'
      end
    else
      user.update_attribute(:incorrect_sign_in_counter, user.incorrect_sign_in_counter != nil ? (user.incorrect_sign_in_counter + 1) : 1) if user
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
