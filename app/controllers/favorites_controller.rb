class FavoritesController < ApplicationController

  before_action :authenticate_user

  def index
    # This will get all the posts that the user has favorited
    @favorite = current_user.favorited_posts
  end

  def create
    post = Post.find(params[:post_id])
    favorite = Favorite.new(post: post, user: current_user)
    if favorite.save
      redirect_to post, notice: "Favorited!"
    else
      redirect_to post, alert: "Favorite not completed try again!"
    end
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    post = Post.find(params[:post_id])
    favorite.destroy
    redirect_to post, notice: "Un-favorited!"
  end

end
