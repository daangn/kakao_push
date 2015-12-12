module KakaoPush
  class Gcm
    def initialize(collapse: nil, delay_while_idle: nil, return_url: nil, custom_field: nil, push_token: nil)
      @collapse = collapse
      @delay_while_idle = delay_while_idle
      @return_url = return_url
      @custom_field = custom_field
      @push_token = push_token
    end

    def to_hash
      for_gcm = {}
      for_gcm['collapse'] = @collapse if !@collapse.nil?
      for_gcm['delay_while_idle'] = @delay_while_idle if !@delay_while_idle.nil?
      for_gcm['return_url'] = @return_url if !@return_url.nil?
      for_gcm['custom_field'] = @custom_field if !@custom_field.nil?
      for_gcm['push_token'] = @push_token if !@push_token.nil?
      for_gcm
    end
  end
end
