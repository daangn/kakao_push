module KakaoPush
  class Apns
    include KakaoPush::ToHashable

    def initialize(badge: nil, sound: nil, push_alert: nil, message: nil, custom_field: nil, push_token: nil)
      @badge = badge
      @sound = sound
      @push_alert = push_alert
      @message = message
      @custom_field = custom_field
      @push_token = push_token
    end
  end
end
