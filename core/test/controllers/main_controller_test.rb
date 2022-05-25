require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get :index" do
    get main_:index_url
    assert_response :success
  end
end
