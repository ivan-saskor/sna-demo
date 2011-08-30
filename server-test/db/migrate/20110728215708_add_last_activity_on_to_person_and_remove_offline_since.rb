class AddLastActivityOnToPersonAndRemoveOfflineSince < ActiveRecord::Migration
  def self.up
    add_column :people, :last_activity_on, :datetime

    Person.all.each do |p|
      p.last_activity_on = p.offline_since
      p.save
    end

    remove_column :people, :offline_since
  end

  def self.down
    add_column :people, :offline_since, :datetime

    Person.all.each do |p|
      p.offline_since = p.last_activity_on
      p.save
    end

    remove_column :people, :last_activity_on
  end
end
