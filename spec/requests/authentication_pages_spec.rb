require 'spec_helper'

describe "Authentication" do # tests for the new session action and view

  subject { page }

  describe "signin page" do

    before { visit signin_path }

    # it { should have_selector('h1',    text: 'Sign In') }
    # it { should have_selector('title', text: 'Sign In') }

    describe "with invalid information" do # test for signin failure
      before { click_button "Sign In" }

      it { should have_selector('title', text: 'Sign In') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      # it { should_not have_link('Profile', href: user_path(user)) }
      it { should_not have_link('Profile') } # tests that link does not appear when a user is not signed in
      
      # it { should_not have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Settings') } # tests that link does not appear when a user is not signed in

      describe "after visiting another page" do # test for signin failure
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do # test for signin success

      let(:user) { FactoryGirl.create(:user) }

      before { sign_in user }

      # before do
        # fill_in "Email",    with: user.email.upcase
        # fill_in "Password", with: user.password
        # click_button "Sign In"
      # end

      it { should have_link('Users',    href: users_path) }
      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign Out', href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "followed by signout" do # test for signing out a user
        before { click_link "Sign Out" }
        it { should have_link('Sign In') }
      end
    end
  end

  describe "authorization" do # testing that the edit and update actions are protected

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Microposts controller" do # access control tests for microposts

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a protected page" do # test for friendly forwarding
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign In"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit User')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign In') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do # testing that the index action is protected
          before { visit users_path }
          it { should have_selector('title', text: 'Sign In') }
        end

      end

      describe "as non-admin user" do # test for protecting the destroy action
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }        
        end
      end

    end

    describe "as wrong user" do # testing that the edit and update actions require the right user
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

end