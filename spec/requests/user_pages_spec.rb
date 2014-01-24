require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end #signup page

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end  #profile page (Factory Girl)

#  describe "profile page" do
#    let(:user) { FactoryGirl.create(:user) }
#    before { visit user_path(user) }

#    it { should have_content(user.name) }
#    it { should have_title(user.name) }
#  end

#  describe "signup page" do
#    before { visit signup_path }
#
#    it { should have_content('Sign up') }
#    it { should have_title(full_title('Sign up')) }
#  end

# Section 7.2 stuff about signup page
  describe "signup page" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end #invalid information

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end #before

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_link('Sign out') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end  #after saving the user

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end  #create a user
    end #with valid information
  end #describe signup page

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end  #not create a user
      describe "after submission" do
        before { click_button submit }
#        it { should have_selector('title',text: 'Sign up') }
        it { should have_content('error') } 
#        it { should have_content('Password digest can\'t be blank') }
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Email can\'t be blank') }
        it { should have_content('Email is invalid') }
        it { should have_content('Password can\'t be blank') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
#        it { should have_content('Password confirmation can\'t be blank') }
      end  #after submission
    end #with invalid information


  end #signup page

  #edit page
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end  #describe edit page

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content("error") }
    end  #edit page - invalid information
  end #edit page

end # user pages

