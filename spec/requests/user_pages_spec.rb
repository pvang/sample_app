require 'spec_helper'

describe "User pages" do
	subject { page }

	describe "signup page" do # test for sign up page content/structure
    	let(:user) { FactoryGirl.create(:user) }

		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign Up') }
		it { should have_selector('title', text: full_title('Sign Up')) }
	end

    describe "signup" do # basic test for signing up users

      before { visit signup_path }

      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
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
    end
  end

end