require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home" do
    it "should have content 'Sample App'" do
      visit root_path
      should have_selector('h1', text: 'Sample App')
    end
  end

  describe "Help" do
    it "should have content 'Help'" do
      visit help_path
      should have_selector('h1', text: 'Help')      
    end
  end

  describe "About" do
    it "should have content 'About'" do
      visit about_path
      should have_selector('h1', text: 'About')
    end
  end

  describe "Contact" do
    it "should have content 'Contact'" do
      visit contact_path
      should have_selector('h1', text: 'Contact')
    end
  end
end
