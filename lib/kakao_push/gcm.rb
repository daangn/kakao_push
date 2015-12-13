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
      Hash[
        instance_variables.map { |var_name|
          [var_name.to_s.gsub('@',''), instance_variable_get(var_name)]
        }.select {|el| el.last }
      ]
    end
  end
end
