class UserMailer < ActionMailer::Base
  default from: "finalfprofi@fantasymail.de"
  
  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>" 
    @site_name = "Fire&RescueGame"
    mail(:to => email_with_name, :subject => "Welcome to Fire&RescueGame")
  end

end
