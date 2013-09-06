module Events
  module Subscriber
    include EventNaming

    def handles?(event_name)
      handler_name = create_handler_name(event_name)
      self.respond_to?(handler_name)
    end
  end
end
