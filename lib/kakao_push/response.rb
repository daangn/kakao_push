require 'multi_json'

module KakaoPush
  class Response
    def initialize(faraday_response)
      @raw_body = faraday_response.body
      @raw_status = faraday_response.status
    end

    def body
      @body ||= MultiJson.load(@raw_body) if !@raw_body.nil?
    end

    def status
      @raw_status
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
      if fail? && body.is_a?(Hash) && body.has_key?('code')
        return body['code']
      end
      nil
    end

    def error_message
      if fail? && body.is_a?(Hash) && body.has_key?('msg')
        return body['msg']
      end
      nil
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
  end
end
