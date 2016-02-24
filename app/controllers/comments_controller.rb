# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class CommentsController < ApplicationController

  before_action :authenticate_user

  def create
    @post = Post.find(params[:post_id])
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), notice: "Comment successfully logged"
    else
      # this is actually a direct to the posts folder and looking for the show file
      # not actually a url posts_path
      render "/posts/show"
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    redirect_to root_path, alert: "ACCESS DENIED" unless can? :manage, comment
    comment.destroy
    redirect_to post_path(params[:post_id]), notice: "Comment was deleted."
  end
end
