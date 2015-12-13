module KakaoPush
  class Client
    API_HOST = "https://kapi.kakao.com"

    attr_accessor :rest_api_key

    def initialize(rest_api_key:)
      @rest_api_key = rest_api_key

      self.connection = build_connection
    end

    def register(uuid:, push_type:, device_id:, push_token:)
      body = {
        'uuid' => uuid,
        'device_id' => device_id,
        'push_type' => push_type,
        'push_token' => push_token
      }

      KakaoPush::Response.new(
        connection.post do |req|
          req.url url_for('/register')
          req.body = body
        end
      )
    end

    def deregister(uuid:, push_type:, device_id:)
      body = {
        'uuid' => uuid,
        'device_id' => device_id,
        'push_type' => push_type
      }

      KakaoPush::Response.new(
        connection.post do |req|
          req.url url_for('/deregister')
          req.body = body
        end
      )
    end

    def tokens(uuid:)
      KakaoPush::Response.new(
        connection.get do |req|
          req.url url_for('/tokens')
          req.params['uuid'] = uuid
        end
      )
    end

    def send(uuids: [], apns:, gcm:, bypass: false)
      body = {
        'uuids' => uuids.to_json,
        'push_message' => build_message(apns: apns, gcm: gcm).to_json,
        'bypass' => bypass
      }

      KakaoPush::Response.new(
        connection.post do |req|
          req.url url_for('/send')
          req.body = body
        end
      )
    end

    def build_connection(&block)
      Faraday.new(faraday_client_options) do |builder|
        builder.request :url_encoded
        if block.nil?
          builder.adapter Faraday.default_adapter
        else
          block.call(builder)
        end
      end
    end

    private

    attr_accessor :connection

    def faraday_client_options
      {
        headers: {
          "Authorization" => "KakaoAK #{@rest_api_key}"
        },
        url: API_HOST
      }
    end

    def url_for(path)
      "/v1/push#{path}"
    end

    def build_message(apns:, gcm:)
      {
        "for_apns" => apns.to_hash,
        "for_gcm" => gcm.to_hash
      }
    end
  end
end
