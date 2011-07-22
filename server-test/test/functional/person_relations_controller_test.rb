require 'test_helper'

class PersonRelationsControllerTest < ActionController::TestCase
  setup do
    @person_relation = person_relations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_relations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_relation" do
    assert_difference('PersonRelation.count') do
      post :create, :person_relation => @person_relation.attributes
    end

    assert_redirected_to person_relation_path(assigns(:person_relation))
  end

  test "should show person_relation" do
    get :show, :id => @person_relation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @person_relation.to_param
    assert_response :success
  end

  test "should update person_relation" do
    put :update, :id => @person_relation.to_param, :person_relation => @person_relation.attributes
    assert_redirected_to person_relation_path(assigns(:person_relation))
  end

  test "should destroy person_relation" do
    assert_difference('PersonRelation.count', -1) do
      delete :destroy, :id => @person_relation.to_param
    end

    assert_redirected_to person_relations_path
  end
end
