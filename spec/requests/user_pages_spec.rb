require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end      
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
    
    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit edit_user_path(user)
      end
    
      describe "page" do
        it { should have_content("Update your profile") }
        it { should have_title("Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
      end
  
      describe "with invalid information" do
        before { click_button "Save changes" }
  
        it { should have_content('error') }
      end
      
      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirm Password", with: user.password
          click_button "Save changes"
        end
  
        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { expect(user.reload.name).to  eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end
    end
   end 
   
  describe "forgot_password" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Send Password Reset Instructions" }
    before { visit forgot_password_path }
    
    describe "forgot_password_link" do
      before { visit signin_path }
      it { should have_link('Request a password reset?', href: forgot_password_path) }
    end

    describe "forgot_password_page" do
      it { should have_title("Forgot Password") }
    end
    
    describe "with invalid email" do
      before do
        fill_in "user_name",             with: "test6868787@test2373274.de"
        click_button submit
      end
      
      it { should have_content("Name/Email not found") }
      it { should have_title("Forgot Password") }
    end
    
    describe "with invalid name" do
      before do
        fill_in "user_name",             with: "Hans Meier 234"
        click_button submit
      end
      
      it { should have_content("Name/Email not found") }
      it { should have_title("Forgot Password") }
    end
    
    describe "with valid name" do
      before do
        fill_in "user_name",             with: user.name
        click_button submit
      end
      
      it { should have_content("Email sent with password reset instructions.") }
      it { should have_content("home page") }
    end
    
    describe "with valid email" do
      before do
        fill_in "user_name",             with: user.email
        click_button submit
      end
      
      it { should have_content("Email sent with password reset instructions.") }
      it { should have_content("home page") }
    end
  end 
  
  describe "reset_password" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Send Password Reset Instructions" }
    
    describe "reset password page with incorrect token" do
      before { visit password_reset_path(:id => "12389")}
      it { should have_content("You have not requested a password reset.") }
      it { should have_title("") }
    end
    
    describe "reset password page with correct token" do
      before { visit password_reset_path(:id => user.password_reset_token) }
      it { should have_content("Password Reset") }
      it { should have_title("Password Reset") }
      it { should have_content("requested a password reset") }
    end
    
    describe "reset password page with incorrect password length" do      
      before do
          visit password_reset_path(:id => user.password_reset_token)
          fill_in "Password",         with: "12345"
          fill_in "user_password_confirmation", with: "12345"
          click_button "Update Password"
        end
      
      it { should have_content("error") }
      it { should have_title("Password Reset") }
      it { should have_content("requested a password reset") }
    end
    
    describe "reset password page with incorrect password confirmation" do
      before do
          visit password_reset_path(:id => user.password_reset_token)
          fill_in "Password",         with: "Test12345"
          fill_in "user_password_confirmation", with: "Test123"
          click_button "Update Password"
        end
      
      it { should have_content("error") }
      it { should have_title("Password Reset") }
      it { should have_content("requested a password reset") }
    end
    
    describe "reset password page with expired token" do
      let(:wrong_user) { FactoryGirl.create(:user, password_reset_sent_at: Time.now - 3.hours) }
      before do
        visit password_reset_path(:id => wrong_user.password_reset_token)
        fill_in "Password",         with: "Test12345"
        fill_in "user_password_confirmation", with: "Test12345"
        click_button "Update Password"
      end
      
      it { should have_content("Password reset has expired.") }
      it { should have_title("Password Reset") }
      it { should have_content("requested a password reset") }
    end
    
    describe "reset password page with correct password" do
      before do
          visit password_reset_path(:id => user.password_reset_token)
          fill_in "Password",         with: "Test12345"
          fill_in "user_password_confirmation", with: "Test12345"
          click_button "Update Password"
        end
      
      it { should have_content("Password has been reset!") }
      it { should have_title("") }
    end
  end 
end
