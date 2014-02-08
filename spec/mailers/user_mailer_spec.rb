require "spec_helper"

describe UserMailer do
  
  let(:user) { FactoryGirl.create(:user) }
  
  subject { user }
  
  describe 'welcome_mail' do
    let(:mail) { UserMailer.welcome_email(user) }
 
    it 'renders the subject' do
      mail.subject.should == 'Welcome to Fire&RescueGame'
    end
 
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    it 'renders the sender email' do
      mail.from.should == ['finalfprofi@fantasymail.de']
    end
 
    it 'assigns site name' do
      mail.body.encoded.should match("Fire&RescueGame")
    end
    
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
 
  end
  
  describe 'password_reset_mail' do
    let(:mail) { UserMailer.password_reset(user) }
 
    it 'renders the subject' do
      mail.subject.should == 'Fire&RescueGame - Password Reset'
    end
 
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    it 'renders the sender email' do
      mail.from.should == ['finalfprofi@fantasymail.de']
    end
 
    it 'assigns content' do
      mail.body.encoded.should match("requested a password reset")
    end
    
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
    
    it 'assigns @password_reset_url' do
      mail.body.encoded.should match("password_reset\\?id=")
    end
  end
  
  describe 'email_confirmation_mail' do
    let(:mail) { UserMailer.email_confirmation(user) }
 
    it 'renders the subject' do
      mail.subject.should == 'Fire&RescueGame - Email confirmation'
    end
 
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    it 'renders the sender email' do
      mail.from.should == ['finalfprofi@fantasymail.de']
    end
 
    it 'assigns site name' do
      mail.body.encoded.should match("confirm your email address")
    end
    
    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end
    
    it 'assigns @email' do
      mail.body.encoded.should match(user.email)
    end
    
    it 'assigns @password_reset_url' do
      mail.body.encoded.should match("email_confirmation\\?id=")
    end
  end
end
