require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let!(:user) {FactoryGirl.create(:user)}
  let!(:user_1) {FactoryGirl.create(:user)}
  # use this to create valid posts. Since we did not define a user here, the
  # factory will just automatically generate one for us.
  let!(:valid_post) {FactoryGirl.create(:post, {user: user})}
  let!(:valid_post1) {FactoryGirl.create(:post)}
  let(:all_posts) {FactoryGirl.create_list(:post, 10, {user: user})}
  let(:all_posts_1) {FactoryGirl.create_list(:post, 10, {user: user_1})}

  # this will create just a set of valid attributes. Using the create call above will
  # actually call the post :create and generate a valid record.
  let(:valid_post_attributes) {FactoryGirl.attributes_for(:post)}

  # Preventing non-signed in users from creating, updating or deleting posts
  describe "new" do

    context "user is signed in" do
      before {signin(user)}

      it "renders the new template" do
        # This mimics sending a new request
        get :new
        expect(response).to render_template(:new)
      end

      it "instantiates a new Post object and set it to @post" do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context "user is not signed in" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "create" do

    context "user is signed in" do

      before {signin(user)}

      def valid_request
        post :create, post: valid_post_attributes
      end

      context "with valid attributes" do
        it "creates a record in the database" do
          post_count_before = Post.count
          valid_request
          post_count_after = Post.count
          expect(post_count_after-post_count_before).to eq(1)
        end

        it "redirects to the posts show page" do
          valid_request
          expect(response).to redirect_to(post_path(Post.last))
        end

        it "sets a flash notice message" do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do

        def invalid_request
          post :create, post: {title: "Bad", body: Faker::Lorem.paragraph}
        end

        it "doesn't create a record in the database" do
          post_count_before = Post.count
          invalid_request
          post_count_after = Post.count
          expect(post_count_after).to eq(post_count_before)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "sets a flash alert message" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end
    end

    context "user is not signed in" do
      it "redirect_to the user sign in page" do
        post :create, post: valid_post_attributes
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "show" do

    before do
      # Since these actions will be used before every show action we can refactor
      # the code using this before method
      # This will create and post a valid blog post, GIVEN
      valid_post
      # this then calls the show action, WHEN
      get :show, id: valid_post.id
    end

    it "finds the object by its id and sets it to the @post variable" do
      expect(assigns(:post)).to eq(valid_post)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)

    end

    it "raises and error if the id passed doesn't match an id in the db" do
      # with the expect you can actually pass it a block as shown below.
      # we can actually use a matcher to check for errors that have been raised
      expect {get :show, id: 678230}.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe "index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "fetches all the posts and assigns them " do
      # first we need to create some records to push to the database
      # p1 = FactoryGirl.create(:post)
      # p2 = FactoryGirl.create(:post)


      get :index

      # this is accessing the posts that is stored in assigns.
      # assigns is a hash, accessible within Rails tests, containing all the instance
      # variables that would be available to a view at this point. It’s also an
      # accessor that allows you to look up an attribute with a symbol (since,
      # historically, the assigns hash’s keys are all strings). In other words,
      # assigns(:posts) is the same as assigns["posts"]
      expect(assigns(:posts)).to eq([valid_post,valid_post1])
    end
  end

  describe "edit" do
    context "with user signed in" do
      before do
        signin(user)
        get :edit, id: valid_post.id
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

      it "finds the post by id and sets it to the @post instance variable" do
        # get :edit, id: valid_post.id
        expect(assigns(:post)).to eq(valid_post)
      end
    end

    context "with user not signed in" do
      it "redirects to the user sign in page" do
        get :edit, id: valid_post.id
        expect(response).to redirect_to(new_session_path)
      end
    end

  end

  # Preventing logged in users from updating or deleting posts they did not create
  describe "update" do
    context "with user signed in" do

      before {signin(user)}

      context "signed in user is the owner of the post" do
        context "with valid attributes" do

          before do
            # Send a patch/update request, with the an id and an update to that particular
            # post's title.
            patch :update, id: valid_post.id, post: {title: "A new title"}
          end

          it "updates the record with the new parameter(s)" do
            # here we need to call the reload in order to set the title to the object
            expect(valid_post.reload.title).to eq("A new title")
          end

          it "redirects to the post show page" do
            expect(response).to redirect_to(post_path(valid_post))
          end

          it "sends a flash notice" do
            expect(flash[:notice]).to be
          end
        end

        context "with invalid attributes" do

          it "doesn't update the record with the new parameter(s)" do
            post_title = valid_post.title
            patch :update, id: valid_post.id, post: {title: "Title"}
            expect(valid_post.reload.title).to eq(post_title)
          end

          it "renders the edit page" do
            patch :update, id: valid_post.id, post: {title: "Title"}
            expect(response).to render_template(:edit)
          end

          it "sends a flash alert" do
            patch :update, id: valid_post.id, post: {title: "Title"}
            expect(flash[:alert]).to be
          end
        end # End of context with invalid attributes
      end # End of context where user is the owner of the post

      context "signed in user is not the owner of the post" do
        it "raises an error" do
          expect do
            byebug
            patch :update, id: valid_post1.id
            byebug
          end.to raise_error
        end
      end # End of context where signed in user is not the owner of the post
    end # End of context where user is signed in.

    context "with user not signed in" do
      # it "raises an error" do
      #   expect do
      #     patch :update, id: valid_post.id, post: {title: "A new title"}
      #   end.to raise_error(CanCan::AccessDenied)
      # end

      it "redirects to the sign in page" do
        patch :update, id: valid_post.id, post: {title: "A new title"}
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "destroy" do

    context "with signed in user" do

      before {signin(user)}

      it "finds and deletes a record" do
        # first create a valid record
        valid_post.reload
        # Then count how many records you have in the database
        post_count_before = Post.count
        # call the delete action, with a given id.
        delete :destroy , id: valid_post.id
        # check to make sure the post was deleted
        expect(post_count_before - Post.count).to eq(1)
      end

      it "redirect to the index page" do
        delete :destroy, id: valid_post.id
        expect(response).to redirect_to(posts_path)
      end

      it "sends a flash notice" do
        delete :destroy, id: valid_post.id
        expect(flash[:notice]).to be
      end
    end

    context "without signed in user" do
      # it "raises and error" do
      #   expect do
      #     delete :destroy, id: valid_post.id
      #   end.to raise_error(CanCan::AccessDenied)
      # end

      it "redirects to the sign in page" do
        delete :destroy, id: valid_post.id
        expect(response).to redirect_to(new_session_path)
      end

    end

  end

end
