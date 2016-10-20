class EventSwitch < ActiveRecord::Base
  class << self
    def on?(event_name)
      EventSwitch.where(event_name: event_name).first.is_valid
    end
  end
end
