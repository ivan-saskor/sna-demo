include ApiHelper

class Person < ActiveRecord::Base
  has_many :to_relations, :class_name => 'PersonRelation', :foreign_key => 'to_id'
  has_many :from_relations, :class_name => 'PersonRelation', :foreign_key => 'from_id'

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

  def rejected_persons
    return filter_persons 'Rejected'
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
  
  def normalized_relations
    results = []
    self.to_relations.each { |r| results << normalize_relation(r) }
    self.from_relations.each { |r| results << normalize_relation(r) }
    
    return results
  end

  def normalize_relation relation
    if relation.relation_status_code == 'Friend'
      return {:person => relation.from, :friendship_status => 'Friend', :relation => relation} if relation.to == self
      return {:person => relation.to, :friendship_status => 'Friend', :relation => relation} if relation.from == self
      raise "Invalid relation"
    end

    if relation.relation_status_code == 'WaitingForHim'
      return {:person => relation.from, :friendship_status => 'WaitingForMe', :relation => relation} if relation.to == self
      return {:person => relation.to, :friendship_status => 'WaitingForHim', :relation => relation} if relation.from == self
      raise "Invalid relation"
    end

    if relation.relation_status_code == 'Rejected'
      return {:person => relation.from, :friendship_status => 'Rejected', :relation => relation} if relation.to == self
      return {:person => relation.to, :friendship_status => 'Rejected', :relation => relation} if relation.from == self
      raise "Invalid relation"
    end
    raise "Invalid relation"
  end

  def find_relation person
    return self.normalized_relations.select { |r| r[:person] == person }.first[:relation]
  end
end
