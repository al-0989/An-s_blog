class CommentsMailer < ApplicationMailer
  def notify_post_owner(comment)
    # Pass the comment in from the comments controller the create action
    @comment = comment
    # Since we have associations in place we are able to call this in order to return the post associated with the comment
    @post = comment.post
    #find the owner of the user via the post. We need this so that we can email the user.
    @owner = post.user
    mail(to: @owner.email, subject: "You got an answer!")
  end
end
