class AddInterestsToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :interests, :text
  end
end
