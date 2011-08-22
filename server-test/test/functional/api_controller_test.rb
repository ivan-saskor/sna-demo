require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  setup do
    @min_profile = {
                'VisibilityStatus' => 'Online',
                'Nick' => 'TestNick',
                'Email' => 'min@test.com',
                'Password' => 'test123'
              }

    @max_profile = {
                'VisibilityStatus' => 'Online',
                'Nick' => 'TestNick',
                'Email' => 'max@test.com',
                'Password' => 'test1234',
                'Mood' => 'killing time',
                'GravatarCode' => 'www.gravatar.com/me',
                'BornOn' => '1984-06-28',
                'Gender' => 'Male',
                'LookingForGenders' => ['Female'],
                'Phone' => '+38521123321',
                'Description' => 'somebody',
                'Occupation' => 'software engineer',
                'Hobby' => 'bikez',
                'MainLocation' => 'Split',
                'LastKnownLocation' => {'Latitude' => 43.5138, 'Longitude' => 16.4558}
              }
  end

  test 'register minimal profile' do
    set_credentials

    post(:register_profile, {'profileJson' => @min_profile.to_json})
    person = Person.where(:email => @min_profile['Email'])[0]

    assert_response :created
    assert person.visibility_status == @min_profile['VisibilityStatus']
    assert person.nick == @min_profile['Nick']
    assert person.email == @min_profile['Email']
    assert person.password == @min_profile['Password']
  end

  test 'register maximal profile' do
    set_credentials
    
    post(:register_profile, {'profileJson' => @max_profile.to_json})
    person = Person.where(:email => @max_profile['Email'])[0]

    assert_response :created
    assert person.visibility_status == @max_profile['VisibilityStatus']
    assert person.nick == @max_profile['Nick']
    assert person.email == @max_profile['Email']
    assert person.password == @max_profile['Password']
    assert person.mood == @max_profile['Mood']
    assert person.gravatar_code == @max_profile['GravatarCode']
    assert person.born_on.to_s == @max_profile['BornOn']
    assert person.gender == @max_profile['Gender']
    assert person.looking_for_genders_female == true
    assert person.looking_for_genders_male == false
    assert person.looking_for_genders_other == false
    assert person.phone == @max_profile['Phone']
    assert person.description == @max_profile['Description']
    assert person.occupation == @max_profile['Occupation']
    assert person.hobby == @max_profile['Hobby']
    assert person.main_location == @max_profile['MainLocation']
    assert person.last_known_location_latitude == @max_profile['LastKnownLocation']['Latitude']
    assert person.last_known_location_longitude == @max_profile['LastKnownLocation']['Longitude']
  end

  test 'update to minimal profile' do
    request.env['HTTP_EMAIL'] = 'min_update@test.com'
    request.env['HTTP_PASSWORD'] = 'test1234'

    profile = {
                'VisibilityStatus' => 'Offline',
                'Nick' => 'NewNick',
                'Password' => 'NewPassword'
              }

    person = Person.where(:email => request.env['HTTP_EMAIL'])[0]

    put(:update_profile, {'profileJson' => profile.to_json})

    person = Person.where(:email => request.env['HTTP_EMAIL'])[0]

    assert person.visibility_status == profile['VisibilityStatus']
    assert person.nick == profile['Nick']
    assert person.password == profile['Password']
    assert_response :ok
  end
  
  test 'update to maximal profile' do
    request.env['HTTP_EMAIL'] = 'max_update@test.com'
    request.env['HTTP_PASSWORD'] = 'test1234'

    profile = {
                'VisibilityStatus' => 'Offline',
                'Nick' => 'NewNick',
                'Password' => 'NewPassword',
                'Mood' => 'NewMood',
                'GravatarCode' => 'www.gravatar.com/new_me',
                'BornOn' => '1984-07-28',
                'Gender' => 'Other',
                'LookingForGenders' => ['Other'],
                'Phone' => '123',
                'Description' => 'New description',
                'Occupation' => 'Mechanic',
                'Hobby' => 'Collecting stamps',
                'MainLocation' => 'Zagreb',
                'LastKnownLocation' => {'Latitude' => 44.5138, 'Longitude' => 15.4558}
              }

    person = Person.where(:email => request.env['HTTP_EMAIL'])[0]

    put(:update_profile, {'profileJson' => profile.to_json})

    person = Person.where(:email => request.env['HTTP_EMAIL'])[0]

    assert person.visibility_status == profile['VisibilityStatus']
    assert person.nick == profile['Nick']
    assert person.password == profile['Password']
    assert person.mood == profile['Mood']
    assert person.gravatar_code == profile['GravatarCode']
    assert person.born_on.to_s == profile['BornOn']
    assert person.looking_for_genders_female == false
    assert person.looking_for_genders_male == false
    assert person.looking_for_genders_other == true
    assert person.phone == profile['Phone']
    assert person.description == profile['Description']
    assert person.occupation == profile['Occupation']
    assert person.hobby == profile['Hobby']
    assert person.main_location == profile['MainLocation']
    assert person.last_known_location_latitude == profile['LastKnownLocation']['Latitude']
    assert person.last_known_location_longitude == profile['LastKnownLocation']['Longitude']
    assert_response :ok
  end

  test 'request friendship' do
    set_credentials
    message_text = 'Hi!'
    to_person_email = 'z@test.com'
    to_person = Person.find_by_email(to_person_email)
    from_person = Person.find_by_email(request.env['HTTP_EMAIL'])

    post(:request_friendship, :person_email => to_person_email, :message => message_text)

    assert Message.all.select{|m| m.text == message_text && m.to_id == to_person.id && m.from_id == from_person.id}.count == 1
    assert_response :ok
  end
  
  test 'request double friendship fails' do
    set_credentials

    post(:request_friendship, :person_email => 'a', :message => 'Hi!')

    assert_response :bad_request
  end

  test 'reject friendship' do
    set_credentials
    message_text = 'No friendship from me!'
    to_person_email = 'four@test.com'
    to_person = Person.find_by_email(to_person_email)
    from_person = Person.find_by_email(request.env['HTTP_EMAIL'])

    post(:reject_friendship, :person_email => 'four@test.com', :message => message_text)
    
    assert_response :ok
  end

  test 'reset rejected friendship' do
    set_credentials
    message_text = 'Hi!'
    to_person_email = 'five@test.com'
    to_person = Person.find_by_email(to_person_email)
    from_person = Person.find_by_email(request.env['HTTP_EMAIL'])

    post(:request_friendship, :person_email => to_person_email, :message => message_text)

    from_person.reload

    assert_response :ok
    assert from_person.find_friendship_status(to_person) == 'WaitingForHim'
    assert Message.all.select{|m| m.from_id == from_person.id && m.to_id == to_person.id && m.text == message_text}.count == 1
  end

  test 'accept friendship' do
    set_credentials

    message_text = "You are now friend with #{request.env['HTTP_EMAIL']}"
    to_person_email = 'six@test.com'
    to_person = Person.find_by_email(to_person_email)
    from_person = Person.find_by_email(request.env['HTTP_EMAIL'])

    post(:request_friendship, :person_email => to_person_email, :message => message_text)

    assert_response :ok
    assert from_person.find_friendship_status(to_person) == 'Friend'
    assert Message.all.select{|m| m.from_id == from_person.id && m.to_id == to_person.id && m.text == message_text}.count == 1
  end

  test 'send message' do
    set_credentials

    message_text = 'Hello again'
    to_person_email = 'six@test.com'
    to_person = Person.find_by_email(to_person_email)
    from_person = Person.find_by_email(request.env['HTTP_EMAIL'])

    post(:request_friendship, :person_email => to_person_email, :message => message_text)

    assert_response :ok
    assert Message.all.select{|m| m.from_id == from_person.id && m.to_id == to_person.id && m.text == message_text}.count == 1
  end

  test 'mark message read' do
    set_credentials

    message_id = 3

    put(:mark_message_read, :message_id => message_id)
    
    assert_response :ok
    assert Message.find(message_id).read_on.nil? == false
  end


  def set_credentials
    request.env['HTTP_EMAIL'] = 'x'
    request.env['HTTP_PASSWORD'] = 'y'
  end
end
