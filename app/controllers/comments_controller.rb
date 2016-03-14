class CommentsController < ApplicationController

  before_action :find_post, except: [:destroy]
  before_action :authenticate_user, except: [:index]

  # create an index action for the jQuery client
  def index
    render json: @post.comments
  end

  def create
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.post = @post
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        CommentsMailer.notify_post_owner(@comment).deliver_later
        format.html { redirect_to post_path(@post), notice: "Comment successfully logged"}
        format.js { render :comment_created}
      else
        # this is actually a direct to the posts folder and looking for the show file
        # not actually a url posts_path
        format.html { render "/posts/show" }
        format.js { render :comment_failed }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    redirect_to root_path, alert: "ACCESS DENIED" unless can? :manage, @comment
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_path(params[:post_id]), notice: "Comment was deleted."}
      format.js { render :destroy }
    end
  end

  private

  def find_post
    @post = Post.friendly.find(params[:post_id])
  end
end
