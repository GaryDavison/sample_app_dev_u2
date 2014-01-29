require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end #signin page 

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid email/password combination') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
        it { should_not have_link('Sign out',    href: signout_path) }
     end #visiting another page


    end #invalid information



    describe "with valid information" do
      let(:user) { create_user(:user) }
      before { sign_in(user)}
#      before do
#        fill_in "Email",    with: user.email.upcase
#        fill_in "Password", with: user.password
#        click_button "Sign in"
#      end  #before

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end  #followed by signout


    end  #valid information


  end  #signin

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end # visit edit page

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end # submit to update

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end  #visiting the user index

      end #users controller

    end  #non-signed in users


    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end  #GET request

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end #PATCH request
    end #wrong user


    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
#          fill_in "Email",    with: user.email
#          fill_in "Password", with: user.password
#          click_button "Sign in"
        end  #before

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end  #render protected page
        end # after signing in
      end #attempting to visit a protected page
     end  #non-signed-in users  (Sect 9.1.3)

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end #submitting a DELETE request
    end #non-admin-users


    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user, no_capybara: true }

      describe "using a 'new' action" do
        before { get new_user_path }
        specify { response.should redirect_to(root_path) }
      end #new

      describe "using a 'create' action" do
        before { post users_path(user) }
        specify { response.should redirect_to(root_path) }
      end #create
    end #for signed in users




  end  #authorization



end #authentication

#describe "AuthenticationPages" do
#  describe "GET /authentication_pages" do
#    it "works! (now write some real specs)" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get authentication_pages_index_path
#      response.status.should be(200)
#    end
#  end
#end

