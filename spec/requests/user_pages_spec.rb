require 'spec_helper'


describe "UserPages" do
  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('h1', text: 'All users') }

    describe "pagination" do
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li>a', text: user.name)
        end
      end

      it { should have_selector('div.pagination') }
    end

    describe "delete links" do
      it { should_not have_link 'delete' }

      describe "as an admin" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          click_link('Sign out')
          sign_in admin
          visit users_path
        end

        it { should have_link 'delete', href: user_path(User.first) }
        
        it "should be able to delete a user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
      
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_button('Create my account') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:post1) { FactoryGirl.create(:micropost, user: user) }
    let!(:post2) { FactoryGirl.create(:micropost, user: user, content: 'Foo') }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }

    describe "microposts" do
      it { should have_content(post1.content) }
      it { should have_content(post2.content) }
      it { should have_content("Microposts (#{user.microposts.count})") }
    end
  end

  describe "sinup" do
    let(:submit) { "Create my account" }

    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button(submit).not_to change(User, :count)}
      end
    end

    describe "after submission" do
      before { click_button submit }

      it { should have_selector('#error_explanation') }      
      it { should_not have_content('Password digest') }
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "example user"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end


      it "should create a user" do
        expect { click_button(submit).to change(User, :count).by(1) }
      end

      describe "after saving a user" do
        before { click_button submit }

        let(:user) { User.find_by_email('user@example.com') }
        
        it { should have_selector('h1', text: user.name) }
        it { should have_selector(".alert-success", text: 'Welcome') }
        it { should have_link('Sign out') }
        it { should_not have_link('Sign in') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    
    describe "with invalid information" do
      before { click_button('Save changes') }

      it { should have_selector('#error_explanation') }
      it { should have_selector('.alert-error') }
    end

    describe "with valid information" do
      let(:new_name)  { 'New Name' }
      let(:new_email) { 'new_email@example.com' }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button 'Save changes'
      end

      it { should have_selector('.alert-success') }
      it { should have_link('Sign out') }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
