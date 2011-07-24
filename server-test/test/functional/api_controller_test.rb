require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  setup do
    request.env['HTTP_EMAIL'] = 'x'
    request.env['HTTP_PASSWORD'] = 'y'
  end

  test 'register_profile should return created' do
    post :register_profile
    
    assert_response :created
  end

  test 'update_profile should return ok' do
    put :update_profile

    assert_response :ok
  end
end
