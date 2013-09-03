module Events
  module Publisher
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
      if [String, Symbol].include?(event_name_or_event.class) 
        event_name = event_name_or_event
      else
        event_name = EventNaming.create_event_name_from_event(event_name_or_event)
        event_data = event_name_or_event
      end
      subscriber_hander_name = EventNaming.create_handler_name(event_name)
      event_subscribers = subscribers_for_event(event_name)

      event_subscribers.each do |subscriber|
       subscriber.send(subscriber_hander_name, event_data) 
      end
    end

    def subscribers_for_event(event_name)
      subscribers.select do |subscriber|
        subscriber.handles?(event_name)
      end
    end
  end
end
