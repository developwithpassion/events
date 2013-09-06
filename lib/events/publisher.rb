module Events
  module Publisher
    def self.included(base)
      base.send :include, EventNaming
    end

    def subscribers
      @subscribers ||= []
    end

    def add_subscriber(subscriber)
      subscribers << subscriber
    end

    def remove_subscriber(subscriber)
      subscribers.delete(subscriber)
    end

    def publish(event_name_or_event, event_data=nil)
      event_details = create_event_details(event_name_or_event, event_data)
      event_subscribers = subscribers_for_event(event_details.event_name)

      event_subscribers.each do |subscriber|
       event_details.publish_to(subscriber) 
      end
    end

    def subscribers_for_event(event_name)
      subscribers.select do |subscriber|
        subscriber.handles?(event_name)
      end
    end

    class EventDetails
      include Initializer
      include EventNaming

      initializer :event_name, 
                  :event_data

      def handler_name
        @handler_name ||= create_handler_name(event_name)
      end

      def publish_to(subscriber)
        subscriber.send(handler_name, event_data)
      end
    end

    protected
      def create_event_details(event_or_event_name, event_data=nil)
        named_event = [String, Symbol].include?(event_or_event_name.class)
        return EventDetails.new(event_or_event_name.to_s, event_data) if named_event

        event_name = create_event_name_from_event(event_or_event_name)
        event_data = event_or_event_name
        details = EventDetails.new(event_name, event_data)
      end
  end
end
