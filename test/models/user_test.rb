require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "fixture user authenticates with password" do
    user = users(:one)

    assert user.authenticate("password")
    assert_not user.authenticate("wrong-password")
  end

  test "has_secure_password hashes password on create" do
    user = User.create!(
      email: "newuser@example.com",
      password: "password",
      password_confirmation: "password"
    )

    assert user.password_digest.present?
    assert user.authenticate("password")
  end
end
