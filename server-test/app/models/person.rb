include ApiHelper

class Person < ActiveRecord::Base
  has_many :to_relations, :class_name => 'PersonRelation', :foreign_key => 'to_id'
  has_many :from_relations, :class_name => 'PersonRelation', :foreign_key => 'from_id'

  after_initialize :default_values

  def offline_since
    return ['Invisible', 'Offline'].include?(self.real_visibility_status) ? self.last_activity_on : nil
  end

  def real_visibility_status
    return (self.last_activity_on.advance(:minutes=>5)).past? ? 'Offline' : self.visibility_status
  end
  
  def friends
    return filter_persons 'Friend'
  end

  def aliens
    return Person.all - self.friends - self.persons_waiting_for_him - self.persons_waiting_for_me - self.rejected_persons - [self]
  end

  def persons_waiting_for_him
    return filter_persons 'WaitingForHim'
  end

  def persons_waiting_for_me
    return filter_persons 'WaitingForMe'
  end

  def last_known_location
    throw "Invalid last known location" unless self.last_known_location_latitude.nil? == self.last_known_location_longitude.nil?
    
    return self.last_known_location_latitude.nil? ? nil : {:latitude => self.last_known_location_latitude, :longitude => self.last_known_location_longitude}
  end

  def last_known_location_to_s
    return self.last_known_location.nil? ? '' : "(#{self.last_known_location_latitude}, #{self.last_known_location_longitude})"
  end

  def rejected_persons
    return filter_persons 'Rejected'
  end

  def looking_for_genders
    result = []
    result << 'Male' if self.looking_for_genders_male
    result << 'Female' if self.looking_for_genders_female
    result << 'Other' if self.looking_for_genders_other

    return result
  end

  def filter_persons friendship_status
    results = []
    self.normalized_relations.each do |r|
        if r[:friendship_status] == friendship_status
          results << r[:person]
        end
    end
    return results
  end

  def find_friendship_status person
    self.normalized_relations.each do |r|
        if r[:person] == person
          return r[:friendship_status]
        end
    end

    return person == self ? 'Self' : 'Alien'
  end

  def find_rejected_on person
    return person.find_normalized_relation(self).nil? ? nil : person.find_normalized_relation(self)[:rejected_on]
  end

  def calculate_distance lat_1, lng_1, lat_2, lng_2
    r = 6371
    d_lat = (lat_2 - lat_1)/180 * Math::PI
    d_lng = (lng_2 - lng_1)/180 * Math::PI
    lat_1 = lat_1/180 * Math::PI
    lat_2 = lat_2/180 * Math::PI

    a = Math::sin(d_lat/2) * Math::sin(d_lat/2) +
        Math::sin(d_lng/2) * Math::sin(d_lng/2) * Math::cos(lat_1) * Math::cos(lat_2);
    c = 2 * Math::atan2(Math.sqrt(a), Math::sqrt(1-a));
    d = r * c;
    return d.round
  end

  def find_distance_from person
    return 0 if person == self
    return nil if person.last_known_location.nil? || self.last_known_location.nil?
    
    return calculate_distance person.last_known_location_latitude, person.last_known_location_longitude, self.last_known_location_latitude, self.last_known_location_longitude
  end

  def normalized_relations
    results = []
    self.to_relations.each { |r| results << normalize_relation(r) }
    self.from_relations.each { |r| results << normalize_relation(r) }
    
    return results
  end

  def normalize_relation relation
    if relation.relation_status_code == 'Friend'
      return {:person => relation.from, :friendship_status => 'Friend', :rejected_on => relation.rejected_on, :relation => relation} if relation.to == self
      return {:person => relation.to, :friendship_status => 'Friend', :rejected_on => relation.rejected_on, :relation => relation} if relation.from == self
      raise "Invalid relation"
    end

    if relation.relation_status_code == 'WaitingForHim'
      return {:person => relation.from, :friendship_status => 'WaitingForMe', :rejected_on => relation.rejected_on, :relation => relation} if relation.to == self
      return {:person => relation.to, :friendship_status => 'WaitingForHim', :rejected_on => relation.rejected_on, :relation => relation} if relation.from == self
      raise "Invalid relation"
    end

    if relation.relation_status_code == 'Rejected'
      return {:person => relation.from, :friendship_status => 'Rejected', :rejected_on => relation.rejected_on, :relation => relation} if relation.to == self
      return {:person => relation.to, :friendship_status => 'Rejected', :rejected_on => relation.rejected_on, :relation => relation} if relation.from == self
      raise "Invalid relation"
    end
    
    raise "Invalid relation"
  end

  def find_relation person
    return self.find_normalized_relation(person)[:relation]
  end

  def find_normalized_relation person
    return self.normalized_relations.select { |r| r[:person] == person }.first
  end

  def validation_errors
    person = self
    result = []
    #throw person.gender


    result << "Invalid email"                   unless !person.email.nil? && !person.email.empty?
    result << "Invalid password"                unless !person.password.nil? && !person.password.empty?
    result << "Invalid visibility status"       unless ['Invisible', 'Online', 'ContactMe'].include?(person.visibility_status)
    result << "Invalid real visibility status"  unless person.real_visibility_status == 'Offline' || person.real_visibility_status == person.visibility_status
    result << "Invalid last activity on"        unless person.last_activity_on.acts_like?(:time)
    result << "Invalid offline since"           unless person.offline_since.nil? || person.offline_since == person.last_activity_on
    result << "Invalid offline since"           unless (!person.offline_since.nil? && (person.real_visibility_status == 'Offline' || person.real_visibility_status == 'Invisible')) ||
                                                    (person.offline_since.nil? && person.real_visibility_status != 'Offline' && person.real_visibility_status != 'Invisible')
    result << "Invalid nick"                    unless !person.nick.nil? && !person.nick.empty?
    result << "Invalid mood"                    unless !person.mood.nil?
    result << "Invalid gravatar code"           unless person.gravatar_code.nil? || !person.gravatar_code.empty?
    result << "Invalid born on"                 unless person.born_on.nil? || person.born_on.acts_like?(:date)
    result << "Invalid gender"                  unless person.gender.nil? || ['Male', 'Female', 'Other'].include?(person.gender)
    result << "Invalid looking for genders"     unless !person.looking_for_genders.nil? && person.looking_for_genders.all? {|g| ['Male', 'Female', 'Other'].include?(g)}
    result << "Invalid phone"                   unless !person.phone.nil?
    result << "Invalid description"             unless !person.description.nil?
    result << "Invalid ocupation"               unless !person.occupation.nil?
    result << "Invalid hobby"                   unless !person.hobby.nil?
    result << "Invalid main location"           unless !person.main_location.nil?
    result << "Invalid last known location"     unless person.last_known_location_latitude.nil? == person.last_known_location_longitude.nil?
    result << "Invalid last known location latitude" unless person.last_known_location_latitude.nil? || person.last_known_location_latitude >= -90 && person.last_known_location_latitude <= 90 && person.last_known_location_latitude == person.last_known_location_latitude.round(4)
    result << "Invalid last known location longitude" unless person.last_known_location_longitude.nil? || person.last_known_location_longitude >= -180 && person.last_known_location_longitude <= 180 && person.last_known_location_longitude == person.last_known_location_longitude.round(4)

    return result
  end

  def api_validation_errors current_user
    result = validation_errors
    friendship_status = current_user.find_friendship_status(self)

    result << "Invalid FriendshipStatus" unless ['Self', 'Friend', 'Alien', 'WaitingForHim', 'WaitingForMe', 'Rejected'].include?(current_user.find_friendship_status(self)) &&
                                            (self == current_user && current_user.find_friendship_status(self) == 'Self' ||
                                            self != current_user && current_user.find_friendship_status(self) != 'Self')

    
    rejected_on = current_user.find_rejected_on(self)

    result << "Invalid Rejected_on" unless (!rejected_on.nil? && friendship_status == 'Rejected') ||
                                        (rejected_on.nil? && friendship_status != 'Rejected')

    result << "Invalid distance" unless current_user.find_distance_from(self).nil? || current_user.find_distance_from(self) >= 0
    
    return result
  end

  private
  def default_values
    self.last_activity_on ||= DateTime.now
    self.mood ||= ''
    self.phone ||= ''
    self.description ||= ''
    self.occupation ||= ''
    self.hobby ||= ''
    self.main_location ||= ''
  end
end
