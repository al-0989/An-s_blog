require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  # Created 2 users in order to test that the posts are associated with the
  # correct user.
  let(:user) {FactoryGirl.create(:user)}
  let(:user_1) {FactoryGirl.create(:user)}

  # The create list will generate 10 posts all associated with the user provided
  let(:all_posts) {FactoryGirl.create_list(:post, 10, {user: user})}
  let(:all_posts_1) {FactoryGirl.create_list(:post, 10, {user: user_1})}

  describe "associated posts" do

    context "user is logged in" do
      before {signin(user)}

        it "should show all posts belonging to the user" do
          # Need to run the all_posts commands first to generate the 10 posts per user
          all_posts
          all_posts_1
          get :show, id: user.id
          expect(user.posts.count).to eq(10)
        end
    end

    context "user is not logged" do
      before {signin(user)}

      it "sets a user instance variable" do
        get :show, id: user_1.id
        expect(response).to redirect_to(posts_path)
      end
    end

    context "user is not logged" do
      it "sets a user instance variable" do
        get :show, id: user_1.id
        expect(assigns(:user_1)).not_to eq(user)
      end

      it "should redirect to the login page" do
        # all_posts
        # all_posts_1
        get :show, id: user.id
        expect(response).to redirect_to(new_session_path)
      end
    end

  end
end
