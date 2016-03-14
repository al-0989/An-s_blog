class PostsController < ApplicationController

  # load_and_authorize_resource
  # This would allow a first time vistor to browse the page but not to actually
  # create or edit a post unless they are logged in.
  before_action :find_post, only: [:show, :edit, :update, :delete]
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    # Create an instance variable in order to pass the posts along to The
    # index.html.erb page.
    # ** Note ** that an instance variable is only good for the method (action)
    # in which it is created. This means that the info stored in @posts here is
    # only good for passing info to the index.html.erb page.
    if params[:search]
      @posts = Post.search(params[:search]).page(params[:page]).per(10)
    else
      @posts = Post.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html { render }
      format.json { render json: @posts}
    end
  end

  def new
    # Creating a new post object that will store all the info gathered from
    # the form rendered by the new.html.erb
    # *** Check to see why this @post is needed. Is it only because of the .errors
    @post = Post.new
  end

  def create
    # This is called by the post action which comes from the submit button
    # that is within the form_for. The form_for by default uses the post action
    # for the submit button with the action/route of "/posts" => "/posts#create"
    post_params = params.require(:post).permit(:title,:body,:category_id)
    # Create a new post obj/ActiveRecord and save the values entered in the form_for
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      # if the post is save successfully, let the user know and redirect them to
      # the post that they just created.
      flash[:notice] = "Post Created Successfully"
      redirect_to post_path(@post)
    else
      # if the post fails to create. Re-render the new post page.
      flash[:alert] = "Failed to create post."
      render :new
    end
  end

  def show
    # First find the post to show. Use the find method and pass in a post ID
    @comment = Comment.new
    respond_to do |format|
      format.html {render}
      format.json {render json: @post}
    end
  end

  def edit
    # First find the post that we want to edit
    # @post = current_user.post.find(:id)
  end

  def update
    # This action is what will happen when the form gets submitted after edits
    # have been made.
    # This is to create the friendly ID
    @post.slug = nil
    # First find the post that we want to update.
    # Then get the new params from the submit call and sanitize them.
    post_params = params.require(:post).permit(:title,:body,:category_id)
    # Now update the post with those params.
    if @post.update(post_params)
      # if the post successfully updates, inform the user and redirect to the
      # updated post
      redirect_to post_path(@post), notice: "Post successfully updated!"
    else
      flash[:alert] = "Post failed to update!"
      render :edit
    end
  end

  def destroy
    # First find the post that we want to delete
    # Use destroy instead of delete since destory will also look at and remove
    # any associted values from the db
    @post.destroy
    # Once deleted inform the user and redirect back to the index
    redirect_to posts_path, notice: "#{@post.title} has successfully been deleted."
  end

  private

  def find_post
    @post = Post.friendly.find(params[:id])
  end

  def authorize_user
    # can? is another built-in method that is provided to us by cancancan
    unless can? :manage, @post
      redirect_to root_path, alert: "ACCESS DENIED!"
    end
  end
end
