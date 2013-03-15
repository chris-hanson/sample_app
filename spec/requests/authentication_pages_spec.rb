require 'spec_helper'

describe "AuthenticationPages" do
  subject {page}

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

      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('.alert-success') }
      it { should have_selector('h1', text: user.name) }
      it { should have_link('Sign out') }
      it { should_not have_link('Sign in') }

      describe "followed by signout" do
        before { click_link 'Sign out' }
        it { should have_selector('.alert-success') }
        it { should have_link('Sign up') }
      end
    end

  end
end
