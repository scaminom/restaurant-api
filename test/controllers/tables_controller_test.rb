require "test_helper"

class TablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @table = tables(:one)
  end

  test "should get index" do
    get tables_url, as: :json
    assert_response :success
  end

  test "should create table" do
    assert_difference("Table.count") do
      post tables_url, params: { table: { capacity: @table.capacity, status: @table.status } }, as: :json
    end

    assert_response :created
  end

  test "should show table" do
    get table_url(@table), as: :json
    assert_response :success
  end

  test "should update table" do
    patch table_url(@table), params: { table: { capacity: @table.capacity, status: @table.status } }, as: :json
    assert_response :success
  end

  test "should destroy table" do
    assert_difference("Table.count", -1) do
      delete table_url(@table), as: :json
    end

    assert_response :no_content
  end
end
