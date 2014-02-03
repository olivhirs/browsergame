class UserMailer < ActionMailer::Base
  default from: "finalfprofi@fantasymail.de"
  
  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>" 
    @site_name = "Fire&RescueGame"
    mail(:to => email_with_name, :subject => "Welcome to Fire&RescueGame")
  end
  
  def password_reset(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>" 
    mail(:to => email_with_name, :subject => "Fire&RescueGame - Password Reset")
  end
  
  def email_confirmation(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>" 
    mail(:to => email_with_name, :subject => "Fire&RescueGame - Email confirmation")
  end

end
