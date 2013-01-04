require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

  context "#new" do 
    context "when not logged in" do
      should 'redirect to the login page' do
        get :new
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:chris)
      end
      should "get new and return 200" do
        get :new
        assert_response :success
      end
      
      should "should set a flash error if the friend_id params is missing" do 
        get :new, {}
        assert_equal "friend required", flash[:error]
      end

      should "display the friend's name" do
        get :new, friend_id: users(:jim)
        assert_match /#{users(:jim).full_name}/, response.body
      end

      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:jim)
        assert_equal users(:jim), assigns(:user_friendship).friend
      end

      should "assign a new user friendship to the currently logged in user" do
        get :new, friend_id: users(:jim)
        assert_equal users(:chris), assigns(:user_friendship).user
      end

      should "render a 404 page if the friend is not found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end

      should "ask if you really want to friend this user" do 
        get :new, friend_id: users(:jim)
        assert_match /Do you really want to friend #{users(:jim).full_name}?/, response.body
      end

    end
  end

  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:chris)
      end

      context "with no friend _id" do 
        setup do 
          post :create 
        end
        should "set the flash error message" do
          assert !flash[:error].empty?
        end
        should "redirect to the site root" do 
          assert_redirected_to root_path
        end
      end

      context "with a valid friend_id" do 
        setup do 
          post :create, user_friendship:{friend_id: users(:mike)}
        end

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:mike), assigns(:friend)
        end

        should "assign a user friendship object" do 
          assert assigns(:user_friendship)
          assert_equal users(:chris), assigns(:user_friendship).user
          assert_equal users(:mike), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:chris).friends.include?(users(:mike))
        end

        should "redirect to the profile path of the friend" do 
          assert_response :redirect
          assert_redirected_to profile_path(users(:mike))
        end

        should "set the flash success message" do 
          assert flash[:success]
          assert_equal "You are now friends with #{users(:mike).full_name}", flash[:success]
        end


      end

    end

  end



end
