class FavoritesController < ApplicationController

  before_action :authenticate_user

  def index
    # This will get all the posts that the user has favorited
    @favorite = current_user.favorited_posts
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = Favorite.new(post: @post, user: current_user)
    respond_to do |format|
      if favorite.save
        format.html { redirect_to @post, notice: "Favorited!" }
        # this will look for a favorited.js.erb file to render
        format.js { render :favorited }
      else
        format.html { redirect_to @post, alert: "Favorite not completed try again!"}
        # this will look for an unfavorited.js.erb file to render
        format.js { render :unfavorited }
      end
    end
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    @post = Post.find(params[:post_id])
    favorite.destroy
    respond_to do |format|
      format.html {redirect_to @post, notice: "Un-favorited"}
      format.js { render }
    end
  end

end
