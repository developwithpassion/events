module Events
  module Subscriber
    def self.included(base)
      base.send :include, EventNaming
    end

    def handles?(event_name)
      handler_name = create_handler_name(event_name)
      self.respond_to?(handler_name)
    end
  end
end
