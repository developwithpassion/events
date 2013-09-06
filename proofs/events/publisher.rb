require_relative '../proofs_init'

title 'Publisher'

module PublisherProofs
  module Builder
    extend self

    class SomeAggregator
      include ::Events::Publisher

      module Proof
        def subscriber?(subscriber)
          subscribers.include?(subscriber)
        end

        def published_event?(subscriber, event)
          subscriber.handled?(event)
        end
      end
    end

    class FakeHandler
      include Initializer
      initializer :handles

      def handle_some_event(event)
        @event = event
      end

      def handled?(event)
        @event == event
      end

      def handles?(event_name)
        handles
      end
    end

    class SomeEvent

    end

    def sut
      SomeAggregator.new
    end

    def handler(handles)
      FakeHandler.new(handles)
    end

    def event
      SomeEvent.new
    end
  end
end

def build
  PublisherProofs::Builder
end

heading 'Registering a subscriber' do
  sut = build.sut
  subscriber = Object.new

  sut.add_subscriber(subscriber)

  proof 'Adds it to the list of subscribers' do
    sut.prove { subscriber?(subscriber) }
  end
end

heading 'Removing a subscriber' do
  sut = build.sut
  subscriber = Object.new
  sut.add_subscriber(subscriber)


  sut.remove_subscriber(subscriber)
  proof 'Removes it from the list of subscribers' do
    sut.prove { ! subscriber?(subscriber) }
  end
end

heading 'Publishing an event' do
  event_name = :some_event
  event = build.event
  handler = build.handler(true)
  non_handler = build.handler(false)


  sut = build.sut
  sut.add_subscriber(handler)
  sut.add_subscriber(non_handler)

  sut.publish(event)
  proof 'Triggers the handler method for each of the subscribers that respond to the event' do
    sut.prove do 
      published_event?(handler, event) &&
        ! published_event?(non_handler, event)
    end
  end
end

heading 'Publishing a named event with data' do
  event_name = :some_event
  data = build.event
  handler = build.handler(true)
  non_handler = build.handler(false)


  sut = build.sut
  sut.add_subscriber(handler)
  sut.add_subscriber(non_handler)

  sut.publish(:some_event, data)
  proof 'Triggers the handler method for each of the subscribers that respond to the event' do
    sut.prove do 
      published_event?(handler, data) &&
        ! published_event?(non_handler, data)
    end
  end
end
