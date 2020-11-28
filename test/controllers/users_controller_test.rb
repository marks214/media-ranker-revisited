require 'test_helper'

describe UsersController do

  describe 'login and logged in users' do
    it 'can log in an existing user' do
      user = perform_login(users(:ada))

      must_respond_with :redirect
    end

    it 'can log in a new user' do
      new_user = User.new(
        username: 'Hello World',
        provider: 'github',
        email: 'hw@hw.net',
        uid: '1234',
        name: 'Very Serious'
                          )

      expect {
        logged_in_user = perform_login(new_user)
      }.must_change 'User.count', 1
    end

    describe 'current' do
      it 'returns 200 OK for a logged-in user' do
        # Arrange
        perform_login

        # Act
        # TODO: check this path, chris had current_user_path,
        # this should be users/:id? or:
        get users_path
        #get github_login_path
        #get omniauth_callback_path

        # Assert
        must_respond_with :success
      end
    end

    describe "logout" do
      it "can logout an existing user" do

        # Arrange
        perform_login

        expect(session[:user_id]).wont_be_nil

        delete logout_path, params: {}

        expect(session[:user_id]).must_be_nil
        must_respond_with :redirect
        must_redirect_to root_path

      end
    end

    describe "Guest users" do

      # it "can acces the index" do
      #   get works_path
      #   must_resgpond_with :success
      # end
      #
      # it "cannot access new" do
      #   get new_work_path
      #   must_redirect_to root_path
      # end
      #
      # it "tries to log out" do
      #   delete logout_path
      #   must_redirect_to root_path
      #   flash[:message].must_equal "Must log in first!"
      # end
    end

  end
end
