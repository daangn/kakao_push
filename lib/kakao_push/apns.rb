module KakaoPush
  class Apns
    def initialize(badge: nil, sound: nil, push_alert: nil, message: nil, custom_field: nil, push_token: nil)
      @badge = badge
      @sound = sound
      @push_alert = push_alert
      @message = message
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
