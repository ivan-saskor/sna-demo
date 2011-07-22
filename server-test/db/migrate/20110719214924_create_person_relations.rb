class CreatePersonRelations < ActiveRecord::Migration
  def self.up
    create_table :person_relations do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :relation_status_code

      t.timestamps
    end
  end

  def self.down
    drop_table :person_relations
  end
end
