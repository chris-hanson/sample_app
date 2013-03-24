require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home" do
    before { visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    it { should have_link('Sign up!') }

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "foobar")
        FactoryGirl.create(:micropost, user: user, content: "bazqux")
        sign_in user
        visit root_path
      end

      it "should render users feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help" do
    before { visit help_path }

    it { should have_selector('h1', text: 'Help') }
  end

  describe "About" do
    before { visit about_path }

    it { should have_selector('h1', text: 'About') }
  end

  describe "Contact" do
    before { visit contact_path }

    it { should have_selector('h1', text: 'Contact') }
  end

  it "should navigate correctly" do
    visit root_path
    click_link 'About'
    should have_selector('h1', text: 'About')
    click_link 'Contact'
    should have_selector('h1', text: 'Contact')
    click_link 'Help'
    should have_selector('h1', text: 'Help')
    click_link 'Home'
    click_link 'Sign up!'
    should have_selector('h1', text: 'Sign up')
    click_link 'Sign in'
    should have_selector('h1', text: 'Sign in')
    click_link 'Sample App v2'
    should have_selector('h1', text: 'Sample App')

  end 
end
