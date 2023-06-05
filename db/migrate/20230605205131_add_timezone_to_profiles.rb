class AddTimezoneToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :time_zone, :string, :default => "Eastern Time (US & Canada)"
  end
end
