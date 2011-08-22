include ApiHelper

class ApiController < ApplicationController
  before_filter :authenticate, :except => [:register_profile]

  def get_data
    render :json => create_data.to_json
  end

  def register_profile
    if params['profileJson'].blank?
      render :json => {'ErrorCode' => 102, 'ErrorMessage' => 'Invalid parameter: profileJson'}, :status => :bad_request
      return
    end
    
    begin
      json_profile = JSON.parse(params['profileJson'])
    rescue
      render :json => {'ErrorCode' => 102, 'ErrorMessage' => 'Invalid parameter: profileJson'}, :status => 	:unprocessable_entity
      return
    end

    person = Person.new
    person.email = json_profile['Email'] if json_profile['Email']

    update_person!(person, json_profile)

    if person.validation_errors.count > 0
      render :json => {'ErrorCode' => 103, 'ErrorMessage' => "Profile validation failed! #{person.validation_errors.inspect}"}, :status => 	:unprocessable_entity
      return
    end
    
    begin
      person.save
    rescue
      render :json => {'ErrorCode' => 104, 'ErrorMessage' => 'Unable to save profile'}, :status => 	:internal_server_error
      return
    end

    render :json => {'StatusCode' => 201, 'StatusMessage' => 'Profile created'}, :status => :created
  end

  def update_profile
    if params['profileJson'].blank?
      render :json => {'ErrorCode' => 102, 'ErrorMessage' => 'Invalid parameter: profileJson'}, :status => :bad_request
      return
    end

    begin
      json_profile = JSON.parse(params['profileJson'])
    rescue
      render :json => {'ErrorCode' => 102, 'ErrorMessage' => 'Invalid parameter: profileJson'}, :status => 	:unprocessable_entity
      return
    end

    person = Person.where(:email => @current_user.email)[0]

    update_person! person, json_profile

    begin
      person.save
    rescue
      render :json => {'ErrorCode' => 104, 'ErrorMessage' => 'Unable to save profile'}, :status => 	:internal_server_error
      return
    end

    render :json => {'StatusCode' => 202, 'StatusMessage' => 'Profile updated'}, :status => :ok
  end

  def request_friendship
    if params['message'].blank?
      render :json => {'ErrorCode' => 102, 'ErrorMessage' => 'Invalid parameter: message'}, :status => :bad_request
      return
    end

    if Person.find_by_email(params[:person_email]).nil?
      render :json => {'ErrorCode' => 110, 'ErrorMessage' => "Email not found: #{params[:person_email]}"}, :status => :unprocessable_entity
      return
    end

    to_person = Person.where(:email => params[:person_email])[0]

    if @current_user.find_friendship_status(to_person) == 'WaitingForHim' || @current_user.find_friendship_status(to_person) == 'Friend'
      render :json => {'ErrorCode' => 111, 'ErrorMessage' => 'Relation between persons already exists'}, :status => :bad_request
      return
    end
    
    if @current_user.find_friendship_status(to_person) == 'Rejected'
      relation = @current_user.find_relation(to_person)
      relation.rejected_on = nil  #take down the rejected flag

      # reset relation direction
      relation.to_id = to_person.id
      relation.from_id = @current_user.id
      
      unless relation.save
        render :json => {'ErrorCode' => 108, 'ErrorMessage' => 'Unable to save new relation'}, :status => :internal_server_error
        return
      end

      message = Message.new(:text => params['message'], :from_id => @current_user.id, :to_id => to_person.id, :sent_on => DateTime.now)
      unless message.save
        render :json => {'ErrorCode' => 106, 'ErrorMessage' => 'Unable to save friendship message'}, :status => :internal_server_error
        return
      end

      render :json => {'StatusCode' => 205, 'StatusMessage' => 'Friendship request renewed'}, :status => :ok
      return
    end

    if @current_user.find_friendship_status(to_person) == 'Alien'
      person_relation = PersonRelation.new(:from_id => @current_user.id, :to_id => to_person.id, :relation_status_code => 'WaitingForHim')
      unless person_relation.save
        render :json => {'ErrorCode' => 105, 'ErrorMessage' => 'Unable to save relation between persons'}, :status => :internal_server_error
        return
      end

      message = Message.new(:text => params['message'], :from_id => @current_user.id, :to_id => to_person.id, :sent_on => DateTime.now)
      unless message.save
        render :json => {'ErrorCode' => 106, 'ErrorMessage' => 'Unable to save friendship message'}, :status => :internal_server_error
        return
      end

      render :json => {'StatusCode' => 203, 'StatusMessage' => 'Friendship request sent'}, :status => :ok
      return
    end
    
    if @current_user.find_friendship_status(to_person) == 'WaitingForMe'
      person_relation = @current_user.find_relation(to_person)

      person_relation.relation_status_code = 'Friend'
      
      unless person_relation.save
        render :json => {'ErrorCode' => 105, 'ErrorMessage' => 'Unable to save relation between persons'}, :status => :internal_server_error
        return
      end

      message = Message.new(:text => params['message'], :from_id => @current_user.id, :to_id => to_person.id, :sent_on => DateTime.now)
      unless message.save
        render :json => {'ErrorCode' => 106, 'ErrorMessage' => 'Unable to save friendship message'}, :status => :internal_server_error
        return
      end

      render :json => {'StatusCode' => 206, 'StatusMessage' => 'Friendship established'}, :status => :ok
      return
    end

    throw 'Invalid state reached in request_friendship method'
    
  end

  def reject_friendship
    if params['message'].blank?
      render :json => {'ErrorCode' => 102, 'ErrorMessage' => 'Invalid parameter: message'}, :status => :bad_request
      return
    end

    if Person.find_by_email(params[:person_email]).nil?
      render :json => {'ErrorCode' => 110, 'ErrorMessage' => "Email not found: #{params[:person_email]}"}, :status => :unprocessable_entity
      return
    end

    from_person = Person.where(:email => params[:person_email])[0]

    person_relation = PersonRelation.all.select{|r| r.from_id == from_person.id && r.to_id == @current_user.id && r.relation_status_code == 'WaitingForHim'}[0]

    if person_relation.nil?
      render :json => {'ErrorCode' => 112, 'ErrorMessage' => "Relationship not found"}, :status => :bad_request
      return
    end

    person_relation.rejected_on = DateTime.now

    unless person_relation.save
      render :json => {'ErrorCode' => 106, 'ErrorMessage' => 'Unable to save reject friendship information'}, :status => :internal_server_error
      return
    end

    message = Message.new(:text => params['message'], :from_id => @current_user.id, :to_id => from_person.id, :sent_on => DateTime.now)
    unless message.save
      render :json => {'ErrorCode' => 107, 'ErrorMessage' => 'Unable to save reject friendship message'}, :status => :internal_server_error
      return
    end

    render :json => {'StatusCode' => 204, 'StatusMessage' => 'Reject friendship request sent'}, :status => :ok
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

  def update_person! person, json_profile
    throw 'Tried to update user with different email' if !json_profile['Email'].nil? && person.email != json_profile['Email']
    
    person.password = json_profile['Password'] if json_profile['Password']
    person.visibility_status = json_profile['VisibilityStatus'] if json_profile['VisibilityStatus']
    person.nick = json_profile['Nick'] if json_profile['Nick']
    person.mood = json_profile['Mood'] if json_profile['Mood']
    person.gravatar_code = json_profile['GravatarCode'] if json_profile['GravatarCode']
    person.born_on = json_profile['BornOn'] if json_profile['BornOn']
    person.gender = json_profile['Gender'] if json_profile['Gender']
    person.looking_for_genders_female = !json_profile['LookingForGenders'].nil? && json_profile['LookingForGenders'].include?('Female')
    person.looking_for_genders_male = !json_profile['LookingForGenders'].nil? && json_profile['LookingForGenders'].include?('Male')
    person.looking_for_genders_other = !json_profile['LookingForGenders'].nil? && json_profile['LookingForGenders'].include?('Other')
    person.phone = json_profile['Phone'] if json_profile['Phone']
    person.description = json_profile['Description'] if json_profile['Description']
    person.occupation = json_profile['Occupation'] if json_profile['Occupation']
    person.hobby = json_profile['Hobby'] if json_profile['Hobby']
    person.main_location = json_profile['MainLocation'] if json_profile['MainLocation']
    person.last_known_location_latitude = json_profile['LastKnownLocation']['Latitude'] if json_profile['LastKnownLocation']
    person.last_known_location_longitude = json_profile['LastKnownLocation']['Longitude'] if json_profile['LastKnownLocation']
  end

  def format_person person
    throw person.api_validation_errors(@current_user) unless person.api_validation_errors(@current_user).empty?
    
    formated_person = {}
    formated_person['Email'] = person.email
    formated_person['Password'] = person.password
    formated_person['VisibilityStatus'] = person.real_visibility_status == 'Invisible' && person != @current_user ? 'Offline' : person.real_visibility_status
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
