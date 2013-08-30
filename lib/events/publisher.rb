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

    def publish(event)
      event_name = EventNaming.create_event_name_from_event(event)
      subscriber_hander_name = EventNaming.create_handler_name(event)
      event_subscribers = subscribers_for_event(event_name)

      event_subscribers.each do |subscriber|
       subscriber.send(subscriber_hander_name, event) 
      end
    end

    def subscribers_for_event(event_name)
      subscribers.select do |subscriber|
        subscriber.handles?(event_name)
      end
    end
  end
end
