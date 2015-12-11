require 'test_helper'

class KakaoPushTest < Minitest::Test
  def setup
    stubs = Faraday::Adapter::Test::Stubs.new
    stubs.post('/v1/push/register', 'device_id=device_id&push_token=push_token&push_type=apns&uuid=') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "uuid can't be null."
        }.to_json
      ]
    }

    stubs.post('/v1/push/register', 'device_id=device_id&push_token=push_token&push_type=apns&uuid=uuid') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "uuid's type should be a numeric."
        }.to_json
      ]
    }

    stubs.post('/v1/push/register', 'device_id=device_id&push_token=push_token&push_type=push_type&uuid=1') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "KpusherPushType type is one of [apns, gcm]. but parameter is aa"
        }.to_json
      ]
    }

    stubs.post('/v1/push/register', 'device_id=device_id&push_token=&push_type=apns&uuid=1') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "push_token can't be null."
        }.to_json
      ]
    }

    stubs.post('/v1/push/register', 'device_id=&push_token=push_token&push_type=apns&uuid=1') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "device_id can't be null."
        }.to_json
      ]
    }

    stubs.post('/v1/push/register', 
      'device_id=device_id&push_token=push_token&push_type=apns&uuid=1',
      {
        'Authorization' => "KakaoAK api_key"
      }
    ) { |env| 
      [
        200,
        {},
        30.to_json
      ]
    }

    stubs.post('/v1/push/deregister', 'device_id=device_id&push_type=apns&uuid=') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "uuid can't be null."
        }.to_json
      ]
    }

    stubs.post('/v1/push/deregister', 'device_id=device_id&push_type=apns&uuid=1') { |env| 
      [
        200,
        {},
        nil
      ]
    }

    stubs.get('/v1/push/tokens?uuid=a') { |env| 
      [
        400,
        {},
        {
          code: -2,
          msg: "uuid's type should be a numeric."
        }.to_json
      ]
    }

    stubs.get('/v1/push/tokens?uuid=1') { |env| 
      [
        200,
        {},
        [{"user_id":"1","device_id":"a","push_type":"apns","push_token":"aaa","created_at":"2015-12-11T11:34:17Z","updated_at":"2015-12-11T11:34:17Z"}].to_json
      ]
    }

    stubs.post('/v1/push/send', 'bypass=&push_message=%7B%22for_apns%22%3A%7B%22for_apns%22%3A%7B%22sound%22%3A%22default%22%2C%22push_alert%22%3Atrue%7D%7D%2C%22for_gcm%22%3A%7B%22for_gcm%22%3A%7B%22custom_field%22%3A%22data%22%7D%7D%7D&uuids=%5B1234%5D') { |env| 
      [
        400,
        {},
        {
          code: -901,
          msg: "push token for ( appId=1111, receiverUserId=1 ) does not exist."
        }.to_json
      ]
    }

    stubs.post('/v1/push/send', 'bypass=&push_message=%7B%22for_apns%22%3A%7B%22for_apns%22%3A%7B%22sound%22%3A%22default%22%2C%22push_alert%22%3Atrue%7D%7D%2C%22for_gcm%22%3A%7B%22for_gcm%22%3A%7B%22custom_field%22%3A%22data%22%7D%7D%7D&uuids=%5B1%5D') { |env| 
      [
        200,
        {},
        nil
      ]
    }

    @client = KakaoPush::Client.new(rest_api_key: 'api_key')
    connection = @client.build_connection do |builder|
      builder.adapter :test, stubs
    end
    @client.__send__(:connection=, connection)
  end

  def test_that_it_has_a_version_number
    refute_nil ::KakaoPush::VERSION
  end

  def test_api_key_invalid
    stubs = Faraday::Adapter::Test::Stubs.new
    stubs.post('/v1/push/register', 
      'device_id=device_id&push_token=push_token&push_type=apns&uuid=1',
      {
        'Authorization' => "KakaoAK invalid_api_key"
      }
    ) { |env|
      [
        401,
        {},
        {
          code: -401, 
          msg: "wrong appKey() format"
        }.to_json
      ]
    }

    client = KakaoPush::Client.new(rest_api_key: 'invalid_api_key')
    connection = client.build_connection do |builder|
      builder.adapter :test, stubs
    end
    client.__send__(:connection=, connection)

    res = client.register(uuid: 1, push_type: 'apns', device_id: 'device_id', push_token: 'push_token')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -401
    refute_nil res.error_message
  end

  def test_register_uuid_empty
    res = @client.register(uuid: '', push_type: 'apns', device_id: 'device_id', push_token: 'push_token')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message

    res = @client.register(uuid: 'uuid', push_type: 'apns', device_id: 'device_id', push_token: 'push_token')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message
  end

  def test_register_push_type_invalid
    res = @client.register(uuid: 1, push_type: 'push_type', device_id: 'device_id', push_token: 'push_token')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message
  end

  def test_register_device_id_empty
    res = @client.register(uuid: 1, push_type: 'apns', device_id: '', push_token: 'push_token')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message
  end

  def test_register_push_token_empty
    res = @client.register(uuid: 1, push_type: 'apns', device_id: 'device_id', push_token: '')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message
  end

  def test_register_success
    res = @client.register(uuid: 1, push_type: 'apns', device_id: 'device_id', push_token: 'push_token')
    assert res.success?
    refute res.fail?
    assert_equal res.data, 30
    assert_nil res.error_code
    assert_nil res.error_message
  end

  def test_deregister_invalid
    res = @client.deregister(uuid: '', push_type: 'apns', device_id: 'device_id')
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message
  end

  def test_deregister_success
    res = @client.deregister(uuid: 1, push_type: 'apns', device_id: 'device_id')
    assert res.success?
    refute res.fail?
  end

  def test_tokens_invalid
    res = @client.tokens(uuid: "a")
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -2
    refute_nil res.error_message
  end

  def test_tokens_success
    res = @client.tokens(uuid: 1)
    assert res.success?
    refute res.fail?
    refute_nil res.data
    assert_equal res.data.first['user_id'], "1"
  end

  def test_send_fail
    apns = KakaoPush::Apns.new(badge: nil, sound: 'default', push_alert: true, message: nil, custom_field: nil, push_token: nil)
    gcm = KakaoPush::Gcm.new(collapse: nil, delay_while_idle: nil, return_url: nil, custom_field: 'data', push_token: nil)
    res = @client.send(uuids: [1234], apns: apns, gcm: gcm, bypass: false)
    refute res.success?
    assert res.fail?
    refute_nil res.error_code
    assert_equal res.error_code, -901
    refute_nil res.error_message
  end

  def test_send_success
    apns = KakaoPush::Apns.new(badge: nil, sound: 'default', push_alert: true, message: nil, custom_field: nil, push_token: nil)
    gcm = KakaoPush::Gcm.new(collapse: nil, delay_while_idle: nil, return_url: nil, custom_field: 'data', push_token: nil)
    res = @client.send(uuids: [1], apns: apns, gcm: gcm, bypass: false)
    assert res.success?
    refute res.fail?
  end
end
