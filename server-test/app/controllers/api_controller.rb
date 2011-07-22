include ApiHelper

class ApiController < ApplicationController
  def data

    user = Person.where(:email => params[:email], :password => params[:password]).first

    if user == nil
      render :json => {'ErrorCode' => 101, 'ErrorMessage' => 'Invalid user data'}, :status => :unauthorized
      return
    end

    search_results = Person.all.select{|p| p != user}
    persons = ([user] + user.friends + user.persons_waiting_for_me + user.persons_waiting_for_him + search_results).uniq

    messages = Message.all.select{|m| m.from == user || m.to == user}
    
    render :json => {
      'Persons' => format_persons(persons, user),
      'User' => user.email,
      'SearchResults' => format_emails(search_results),
      'Messages' => format_messages(messages)
    }.to_json
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
