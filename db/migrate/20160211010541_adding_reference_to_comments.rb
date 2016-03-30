class AddingReferenceToComments < ActiveRecord::Migration
  def change
    remove_reference :posts, :comment, index: true, foreign_key: true
    add_reference :comments, :post, index: true, foreign_key: true
  end
end
