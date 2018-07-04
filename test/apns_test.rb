require 'test_helper'

class ApnsTest < Minitest::Test
  def test_to_hash_apns_env_sandbox
    apns = KakaoPush::Apns.new(badge: 5, sound: 'default', push_alert: true, message: 'this is message', custom_field: nil, push_token: 'test token', apns_env: 'sandbox')
    assert_equal(
      {"badge" => 5, "sound" => "default", "push_alert" => true, "message" => "this is message", "push_token" => "test token", "apns_env" => "sandbox"},
      apns.to_hash
    )
  end

  def test_to_hash_apns_env_nil
    apns = KakaoPush::Apns.new(badge: 0, sound: 'default', push_alert: false, message: 'this is message', custom_field: {a: 'c'}, push_token: 'test token', apns_env: nil)
    assert_equal(
      {"badge" => 0, "sound" => "default", "push_alert" => false, "message" => "this is message", "custom_field" => {a: 'c'}, "push_token" => "test token"},
      apns.to_hash
    )
  end
end
