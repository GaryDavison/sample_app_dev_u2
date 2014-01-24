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
    before do
      sign_in user
      visit edit_user_path(user) 
    end # before

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end  #describe edit page

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content("error") }
    end  #edit page - invalid information


    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end   #valid before

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }

    end #valid info

  end #edit page

#index page
  describe "index" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit users_path
    end  #before each
#    before do
#      sign_in FactoryGirl.create(:user)
#      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
#      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
#      visit users_path
#    end #before

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end #User.paginate
      end #should list each user

    end #pagination



#    it "should list each user" do
#      User.all.each do |user|
#        expect(page).to have_selector('li', text: user.name)
#      end  #each loop
#    end  #should list each user

#delete links
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end  #before

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)  #expect
        end #be able to delete another user
        it { should_not have_link('delete', href: user_path(admin)) }
      end  #have link 'delete'
    end #delete links



  end  #describe index




end # user pages

