require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  setup do
    request.env['HTTP_EMAIL'] = 'x'
    request.env['HTTP_PASSWORD'] = 'y'
  end

=begin
  test 'register_profile should return created' do
    profile = {
                'VisibilityStatus' => 'something',
                'SomethingNested' => {
                                      'Element1' => 'Value1',
                                      'Element2' => 'Value2'},
                                      'ArrayType' => ['Arr1', 'Arr2', 'Arr3']
                }

    post(:register_profile, {'profileJson' => profile.to_json})
    
    assert_response :created
  end
=end

  test 'register minimal profile' do
    visibility_status = 'Online'
    nick = 'TestNick'
    email = 'test@test.com'
    password = 'test123'

    profile = {
                'VisibilityStatus' => visibility_status,
                'Nick' => nick,
                'Email' => email,
                'Password' => password
              }

    post(:register_profile, {'profileJson' => profile.to_json})
    person = Person.where(:email => email)[0]

    assert_response :created
    assert person.visibility_status == visibility_status
    assert person.nick == nick
    assert person.email == email
    assert person.password == password
  end

  test 'register maximal profile' do
    
  end

  test 'update to minimal profile' do
    
  end

  test 'update to maximal profile' do

  end

  test 'request friendship' do
    
  end

  test 'reject friendship' do
    
  end

  test 'accept friendship' do

  end

  test 'send message' do
    
  end

  test 'mark message read' do
    
  end

  test 'update_profile should return ok' do
    profile =
    put :update_profile

    assert_response :ok
  end

end
