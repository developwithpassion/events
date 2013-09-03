module Events
  module Subscriber
    def handles?(event_name)
      handler_name = EventNaming::create_handler_name(event_name)
      self.respond_to?(handler_name)
    end
  end
end
