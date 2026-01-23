require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "create with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["token"].present?
    assert_equal @user.email_address, json["email"]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }, as: :json

    assert_response :unauthorized
    json = JSON.parse(response.body)
    assert_equal "Invalid email or password", json["error"]
  end

  test "destroy" do
    session = @user.sessions.create!
    delete session_path, headers: { "Authorization" => "Bearer #{session.token}" }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Logged out", json["message"]
  end
end
