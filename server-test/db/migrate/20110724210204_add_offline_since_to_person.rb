class AddOfflineSinceToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :offline_since, :datetime
  end

  def self.down
    remove_column :people, :offline_since
  end
end
