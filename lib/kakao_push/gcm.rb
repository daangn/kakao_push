module KakaoPush
  class Gcm
    include KakaoPush::ToHashable

    def initialize(
      collapse: nil,
      delay_while_idle: nil,
      time_to_live: nil,
      dry_run: nil,
      priority: nil,
      return_url: nil,
      custom_field: nil,
      push_token: nil
    )
      @collapse = collapse
      @delay_while_idle = delay_while_idle
      @time_to_live = time_to_live
      @dry_run = dry_run
      @priority = priority
      @return_url = return_url
      @custom_field = custom_field
      @push_token = push_token
    end
  end
end
