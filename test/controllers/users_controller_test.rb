require 'test_helper'

describe UsersController do

  describe 'login and logged in users' do
    it 'can log in an existing user' do
      user = users(:ada)
      perform_login(user)
      get users_path
      must_respond_with :success
    end

    it 'can log in a new user' do
      # TODO: returns nil?
      new_user = User.new(
        username: 'meeseeks',
        uid: '1234',
        provider: 'github',
        name: 'Mx. MeeSeeks',
        email: 'hw@hw.net',
        )

      expect {
        perform_login(new_user)
      }.must_change 'User.count', 1

      session[:user_id].must_equal User.last.id
    end

    it "will redirect for invalid user" do
      invalid_user = User.new(
        name: 'Mx. MeeSeeks',
        )

      expect {
        perform_login(invalid_user)
      }.wont_change 'User.count'

      expect { perform_login(invalid_user)
      }.must_be_nil
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
    it 'redirects for non-logged in user' do
      get users_path
      must_respond_with :redirect
    end
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
