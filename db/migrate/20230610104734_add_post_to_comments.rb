class AddPostToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :parent_post, null: false, foreign_key: { to_table: :posts }
  end
end
