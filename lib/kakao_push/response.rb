require 'multi_json'

module KakaoPush
  class Response

    attr_reader :status

    def initialize(faraday_response)
      self.raw_body = faraday_response.body
      self.status = faraday_response.status
      self.body = MultiJson.load(raw_body) if raw_body && !raw_body.empty?
    end

    def success?
      status == 200
    end

    def fail?
      !success?
    end

    def data
      success? ? body : nil
    end

    def error_code
      return if success?
      body['code'] if body.is_a?(Hash) && body.has_key?('code')
    end

    def error_message
      return if success?
      body['msg'] if body.is_a?(Hash) && body.has_key?('msg')
    end

    def to_s
      <<-EOS
KakaoPush::Response
status : #{status}
success? : #{success?}
fail? : #{fail?}
data : #{data}
error_code : #{error_code}
error_message : #{error_message}

      EOS
    end

    private

    attr_writer :status
    attr_accessor :raw_body, :body
  end
end
