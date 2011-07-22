class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :text
      t.integer :from_id
      t.integer :to_id
      t.datetime :sent_on
      t.datetime :read_on

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
