class AddLevelToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :level, :integer, default: 1
  end
end
