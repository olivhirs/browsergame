require "spec_helper"

describe UserMailer do
  
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  subject { @user }
  
  describe 'welcome_mail' do
    let(:mail) { UserMailer.welcome_email(@user) }
 
    it 'renders the subject' do
      mail.subject.should == 'Welcome to Fire&RescueGame'
    end
 
    it 'renders the receiver email' do
      mail.to.should == [@user.email]
    end
 
    it 'renders the sender email' do
      mail.from.should == ['finalfprofi@fantasymail.de']
    end
 
    it 'assigns site name' do
      mail.body.encoded.should match("Fire&RescueGame")
    end
    
    it 'assigns @name' do
      mail.body.encoded.should match(@user.name)
    end
 
  end
end
