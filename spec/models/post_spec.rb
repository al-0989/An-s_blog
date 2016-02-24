require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "doesn't allow creating a post with no title" do
      #Given
      post = Post.new
      #When
      valid_post = post.valid?
      #Then - expect that valid post is going to be
      expect(valid_post).to eq(false)
    end
    it "doesn't allow creating a title with less than 7 characters" do
      post = Post.new(title: "hello")
      valid_post = post.valid?
      expect(valid_post).to eq(false)
    end
    it "doesn't allow creating a post with no body" do
      post = Post.new
      post.valid?
      expect(post.errors).to have_key(:body)
    end
  end

  describe "post snippet method" do
    # Test drive a method `body_snippet` method that returns a maximum of a 100
    # characters with "..." of the body if it's more than a 100 characters long.

    it "returns a string with a body snippet of 100 characters" do
      post = Post.new(title: "Valid title", body: Faker::Lorem.paragraph)
      post.save
      snippet = post.body_snippet(post.body).length
      expect(snippet).to be <= 100
    end
  end
end
