require 'test_helper'

class BiosControllerTest < ActionController::TestCase
  setup do
    @bio = bios(:bio_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bio" do
    assert_difference('Bio.count') do
      post :create, bio: { dates: @bio.dates, entered_service: @bio.entered_service, first_name: @bio.first_name, last_name: @bio.last_name, middle_name: @bio.middle_name, name: @bio.name, parish: @bio.parish, place_of_birth: @bio.place_of_birth }
    end

    assert_redirected_to bio_path(assigns(:bio))
  end

  test "should show bio" do
    get :show, id: @bio
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bio
    assert_response :success
  end

  test "should update bio" do
    patch :update, id: @bio, bio: { dates: @bio.dates, entered_service: @bio.entered_service, first_name: @bio.first_name, last_name: @bio.last_name, middle_name: @bio.middle_name, name: @bio.name, parish: @bio.parish, place_of_birth: @bio.place_of_birth }
    assert_redirected_to bio_path(assigns(:bio))
  end

  test "should destroy bio" do
    assert_difference('Bio.count', -1) do
      delete :destroy, id: @bio
    end

    assert_redirected_to bios_path
  end
end
