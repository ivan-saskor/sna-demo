include ApiHelper

class ApiController < ApplicationController
  before_filter :authenticate

  def get_data

    search_results = Person.all.select{|p| p != @current_user}
    persons = ([@current_user] + @current_user.friends + @current_user.persons_waiting_for_me + @current_user.persons_waiting_for_him + search_results).uniq

    messages = Message.all.select{|m| m.from == @current_user || m.to == @current_user}
    
    render :json => {
      'Persons' => format_persons(persons, @current_user),
      'User' => @current_user.email,
      'SearchResults' => format_emails(search_results),
      'Messages' => format_messages(messages)
    }.to_json
  end

  def register_profile
    render :text => 'abc', :status => :created
  end

  def update_profile
    render :text => 'all ok', :status => :ok
  end

  private
  def format_person person, user
    return {
      'Email' => person.email,
      'Password' => person.password,
      'Nick' => person.nick,
      'Mood' => person.mood,
      'Phone' => person.phone,
      'FriendshipStatus' => user.find_friendship_status(person)
      }
  end

  def format_persons persons, user
    results = []
    persons.each { |p| results << format_person(p, user) }

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
    return {'From' => message.from.email, 'To' => message.to.email, 'Text' => message.text, 'SentOn' => message.sent_on, 'ReadOn' => message.read_on}
  end
end
