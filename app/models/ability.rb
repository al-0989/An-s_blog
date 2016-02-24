class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    # can :read, Post
    #
    # # If the user exists
    # if user.persisted?
    #   # Then they can create a post.
    #   can :create, Post
    # end

    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end

    # can :manage, Post, user_id: user.id
    can :manage, Post do |post|
      # byebug
      post.user == user
    end

    can :manage, Comment do |comment|
      # this allows the owner of the comment or the owner of the question to
      # edit the comments
      # this is grabbing the user of the comment or post and comparing it to
      # the current user. If they match then they can manage it.
      comment.user == user || comment.post.user == user
    end
  end
end
