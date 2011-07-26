class ChangeBornOnColumnInPerson < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.change :born_on, :date
    end
  end

  def self.down
    change_table :people do |t|
      t.change :born_on, :datetime
    end
  end
end
