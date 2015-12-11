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
      for_apns = {}
      for_apns['badge'] = @badge if !@badge.nil?
      for_apns['sound'] = @sound if !@sound.nil?
      for_apns['push_alert'] = @push_alert if !@push_alert.nil?
      for_apns['message'] = @message if !@message.nil?
      for_apns['custom_field'] = @custom_field if !@custom_field.nil?
      for_apns['push_token'] = @push_token if !@push_token.nil?
      { "for_apns" => for_apns }
    end
  end
end
