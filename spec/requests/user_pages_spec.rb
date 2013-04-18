require 'spec_helper'

describe "User pages" do
	subject { page }

  describe "index" do # tests for the user index page

    # let(:user) { FactoryGirl.create(:user) }

    # before do
      # sign_in user
      # visit users_path
    # end

    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All Users') }
    it { should have_selector('h1',    text: 'All Users') }

    describe "pagination" do # tests for pagination

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do # tests for delete links

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it { should_not have_link('delete', href: user_path(admin)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
      end
    end

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end

	describe "signup page" do # test for sign up page content/structure
    let(:user) { FactoryGirl.create(:user) }

		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign Up') }
		it { should have_selector('title', text: full_title('Sign Up')) }
    it { should have_selector('input', value: 'Create My Account') }
	end

  describe "signup" do # basic test for signing up users

    before { visit signup_path }

    let(:submit) { "Create My Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign Up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"

        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('Sign Out') }

          it "should create a user" do
            expect { click_button submit }.to change(User, :count).by(1)
          end
        end
      end
    end

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      # before { visit edit_user_path(user) } # (if one)

      it { should have_selector('input', value: 'Save Changes') }

      before do # adding a signin step to the edit and update tests (if more)
        sign_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it { should have_selector('h1',    text: "Update Your Profile") }
        it { should have_selector('title', text: "Edit User") }
        it { should have_link('Change', href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save Changes" }
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
          click_button "Save Changes"
        end

        it { should have_selector('title', text: new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign Out', href: signout_path) }
        specify { user.reload.name.should  == new_name }
        specify { user.reload.email.should == new_email }
      end      
    end
  end
end