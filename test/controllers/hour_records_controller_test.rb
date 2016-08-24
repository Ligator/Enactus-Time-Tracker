require 'test_helper'

class HourRecordsControllerTest < ActionController::TestCase
  setup do
    @hour_record = hour_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hour_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hour_record" do
    assert_difference('HourRecord.count') do
      post :create, hour_record: { activity_id: @hour_record.activity_id, description: @hour_record.description, user_id: @hour_record.user_id, worked_date: @hour_record.worked_date, worked_hours: @hour_record.worked_hours }
    end

    assert_redirected_to hour_record_path(assigns(:hour_record))
  end

  test "should show hour_record" do
    get :show, id: @hour_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hour_record
    assert_response :success
  end

  test "should update hour_record" do
    patch :update, id: @hour_record, hour_record: { activity_id: @hour_record.activity_id, description: @hour_record.description, user_id: @hour_record.user_id, worked_date: @hour_record.worked_date, worked_hours: @hour_record.worked_hours }
    assert_redirected_to hour_record_path(assigns(:hour_record))
  end

  test "should destroy hour_record" do
    assert_difference('HourRecord.count', -1) do
      delete :destroy, id: @hour_record
    end

    assert_redirected_to hour_records_path
  end
end
