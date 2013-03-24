require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }
    it { should have_selector('h1', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "invalid login" do
      before { click_button 'Sign in' }
      
      it { should have_selector('.alert-error') }
      it { should have_button 'Sign in' }
      
    end
    
    describe "flash shouldn't persist after loading another page" do
      it { should_not have_selector('.alert-error') }
      
    end

    describe "sucessful login" do
      let(:user) { FactoryGirl.create(:user) }

      before { sign_in user }

      it { should have_selector('.alert-success') }
      it { should have_selector('h1', text: user.name) }
      it { should have_link('Sign out') }
      it { should have_link('Settings') }
      it { should have_link('Users') }
      it { should_not have_link('Sign in') }

      describe "followed by signout" do
        before { click_link 'Sign out' }
        it { should have_selector('.alert-success') }
        it { should have_link('Sign up') }
      end
    end
  end

  describe "authorisation" do

    describe "for non signed in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: 'Sign in') }
          it { should have_selector('.alert-notice') }
        end

        describe "submitting to update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting user index" do
          before { visit users_path }
          it { should have_selector('h1', text: 'Sign in') }
        end

        describe "in the Microposts controller" do
          describe "submitting to the create action" do
            before { post microposts_path }
            specify { response.should redirect_to(signin_path) }
          end
          
          describe "submitting to the destroy action" do
            before { delete micropost_path(FactoryGirl.create(:micropost)) }
            specify { response.should redirect_to(signin_path) }
          end
        end
      end

      describe "when accessing a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password 
          click_button "Sign in"
        end

        describe "after siginig in" do
          it "should remember the correct page" do
            page.should have_selector("h1", text: "Update your profile")
          end
        end

        describe "when signing in again" do
          before do
            click_link "Sign out"
            click_link "Sign in"
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password 
            click_button "Sign in"
          end
          
          it { should have_selector('h1', text: user.name) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email:"wrong@example.com") }   
      before { sign_in user }

      describe "visiting Users#edit" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector("h1", "Update your profile"); }
      end

      describe "submitting with PUT request to Users#update" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
        
      end
    end

    describe "as non admin user" do
      let(:user)      { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting DELETE request to Users#destory" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
        
      end
    end
  end
end
