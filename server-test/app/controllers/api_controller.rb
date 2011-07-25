include ApiHelper

class ApiController < ApplicationController
  before_filter :authenticate

  def get_data
    render :json => create_data.to_json
  end

  def register_profile
    render :text => 'bad profile', :status=> :bad_request if params['profileJson'].blank?
    

    profile.from_json(params['profile'])
    
    render :text => 'abc', :status => :created
  end

  def update_profile
    render :text => 'all ok', :status => :ok
  end

  private
  def create_data
    nearby_persons = Person.all.select{|p| p != @current_user}
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

  def format_person person
    throw person.api_validation_errors(@current_user) unless person.api_validation_errors(@current_user).empty?
=begin
    formated_person = {
      'Email' => person.email,
      'Password' => person.password,
      'VisibilityStatus' => person.visibility_status == 'Invisible' && person != @current_user ? 'Offline' : person.visibility_status,

      'FriendshipStatus' => person.find_friendship_status(@current_user),
      'RejectedOn' => 'person',
      'Nick' => person.nick,
      'Mood' => person.mood,
      'Phone' => person.phone
      }
=end
    formated_person = {}

    formated_person['Email'] = person.email
    formated_person['Password'] = person.password
    formated_person['VisibilityStatus'] = person.visibility_status == 'Invisible' && person != @current_user ? 'Offline' : person.visibility_status
    formated_person['OfflineSince'] = person.offline_since unless person.offline_since.nil?
    formated_person['FriendshipStatus'] = @current_user.find_friendship_status(person)
    formated_person['RejectedOn'] = @current_user.find_rejected_on(person) unless @current_user.find_rejected_on(person).nil?
    formated_person['Nick'] = person.nick
    formated_person['Mood'] = person.mood
    formated_person['GravatarCode'] = person.gravatar_code unless person.gravatar_code.nil?
    formated_person['BornOn'] = person.born_on unless person.gender.nil?
    formated_person['Gender'] = person.gender unless person.gender.nil?
    formated_person['LookingForGenders'] = person.looking_for_genders unless person.looking_for_genders.empty?
    formated_person['Phone'] = person.phone
    formated_person['Description'] = person.description
    formated_person['Occupation'] = person.occupation
    formated_person['Hobby'] = person.hobby
    formated_person['MainLocation'] = person.main_location

    return formated_person
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
