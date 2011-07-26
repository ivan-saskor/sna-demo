include ApiHelper

class ApiController < ApplicationController
  before_filter :authenticate

  def get_data
    render :json => create_data.to_json
  end

  def register_profile
    render :text => 'bad profile', :status=> :bad_request if params['profileJson'].blank?
    

    profile = params['profile'].from_json
    
    render :text => 'abc', :status => :created
  end

  def update_profile
    render :text => 'all ok', :status => :ok
  end

  private
  def create_data
    nearby_persons = order_by_relevance(Person.all.select{|p| p != @current_user}).take(50)
    persons = ([@current_user] + 
                @current_user.friends +
                @current_user.persons_waiting_for_me +
                @current_user.persons_waiting_for_him +
                nearby_persons).uniq

    messages = Message.all.select{|m| m.from == @current_user || m.to == @current_user}

    return {
      'Persons' => format_persons(persons),
      'NearbyPersonsEmails' => format_emails(nearby_persons),
      'Messages' => format_messages(messages)
    }
  end

  def create_data_with_message_id message
    data = create_data
    data['MessageId'] = message.id.to_s
    return data
  end

  def order_by_relevance persons
    x = persons.collect{|p| {:person => p, :relevance => calculate_relevance_using_distance(@current_user, p)}}
    y = x.sort { |a, b| a[:relevance] <=> b[:relevance] }

    return y.collect{|p| p[:person]}
  end

  def calculate_relevance_using_distance person_1, person_2
    return person_2.find_distance_from(person_1).nil? ? person_1.calculate_distance(-90, 0, 90, 0) : person_2.find_distance_from(person_1)
  end

  def format_person person
    throw person.api_validation_errors(@current_user) unless person.api_validation_errors(@current_user).empty?
    
    formated_person = {}
    formated_person['Email'] = person.email
    formated_person['Password'] = person.password
    formated_person['VisibilityStatus'] = person.visibility_status == 'Invisible' && person != @current_user ? 'Offline' : person.visibility_status
    formated_person['OfflineSince'] = person.offline_since unless person.offline_since.nil?
    formated_person['FriendshipStatus'] = @current_user.find_friendship_status(person)
    formated_person['RejectedOn'] = @current_user.find_rejected_on(person) unless @current_user.find_rejected_on(person).nil?
    formated_person['Nick'] = person.nick
    formated_person['Mood'] = person.mood unless person.mood.empty?
    formated_person['GravatarCode'] = person.gravatar_code unless person.gravatar_code.nil?
    formated_person['BornOn'] = person.born_on unless person.born_on.nil?
    formated_person['Gender'] = person.gender unless person.gender.nil?
    formated_person['LookingForGenders'] = person.looking_for_genders unless person.looking_for_genders.empty?
    formated_person['Phone'] = person.phone unless person.phone.empty?
    formated_person['Description'] = person.description unless person.description.empty?
    formated_person['Occupation'] = person.occupation unless person.occupation.empty?
    formated_person['Hobby'] = person.hobby unless person.hobby.empty?
    formated_person['MainLocation'] = person.main_location unless person.main_location.empty?
    formated_person['LastKnownLocation'] = format_location(person.last_known_location) unless person.last_known_location.nil?
    formated_person['DistanceInMeters'] = @current_user.find_distance_from(person) unless @current_user.find_distance_from(person).nil?

    return formated_person
  end

  def format_location location
    return {'Latitude' => location[:latitude], 'Longitude' => location[:longitude]}
  end
  
  def format_persons persons
    results = []
    persons.each { |p| results << format_person(p) }

    return results
  end

  def format_emails persons
    results = []
    persons.each { |p| results << p.email }

    return results
  end

  def format_messages messages
    return messages.collect{|m| format_message(m)}
  end

  def format_message message
    return {'Id' => message.id.to_s, 'FromEmail' => message.from.email, 'ToEmail' => message.to.email, 'Text' => message.text, 'SentOn' => message.sent_on, 'ReadOn' => message.read_on}
  end
end
