require 'spec_helper'


describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_button('Create my account') }
    
  end

  describe "profile page" do

    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
  end

  describe "sinup" do
    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        old_count = User.count
        click_button "Create my account"
        User.count.should == old_count
      end
    end

    describe "with valid information" do
      it "should create a user" do
        fill_in "Name", with: "example user"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"

        old_count = User.count
        click_button "Create my account"
        User.count.should == old_count +1
      end
    end
    
  end
end
