class AddFieldsToPersonModel < ActiveRecord::Migration
  def self.up
    add_column :people, :visibility_status, :string
    add_column :people, :gravatar_code, :string
    add_column :people, :born_on, :datetime
    add_column :people, :gender, :string
    add_column :people, :looking_for_genders_male, :boolean
    add_column :people, :looking_for_genders_female, :boolean
    add_column :people, :looking_for_genders_other, :boolean
    add_column :people, :description, :string
    add_column :people, :occupation, :string
    add_column :people, :hobby, :string
    add_column :people, :main_location, :string
    add_column :people, :last_known_location_latitude, :decimal, :precision => 6, :scale => 4
    add_column :people, :last_known_location_longitude, :decimal, :precision => 7, :scale => 4
  end

  def self.down
    remove_column :people, :visibility_status
    remove_column :people, :gravatar_code
    remove_column :people, :born_on
    remove_column :people, :gender
    remove_column :people, :looking_for_genders_male
    remove_column :people, :looking_for_genders_female
    remove_column :people, :looking_for_genders_other
    remove_column :people, :description
    remove_column :people, :occupation
    remove_column :people, :hobby
    remove_column :people, :main_location
    remove_column :people, :last_known_location_latitude
    remove_column :people, :last_known_location_longitude
  end
end
