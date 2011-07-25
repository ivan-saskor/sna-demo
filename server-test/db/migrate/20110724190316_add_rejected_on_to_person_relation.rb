class AddRejectedOnToPersonRelation < ActiveRecord::Migration
  def self.up
    add_column :person_relations, :rejected_on, :datetime
  end

  def self.down
    remove_column :person_relations, :rejected_on
  end
end
