require_relative '../proofs_init'

title 'Subscriber'

module SubscriberProofs
  module Builder
    extend self

    class SomeSubscriber
      include ::Events::Subscriber

      handle :some_event do |event|
        @event = event
      end

      module Proof
        def handled?(event)
          @event == event
        end
      end
    end

    def subscriber
      SomeSubscriber.new
    end
  end
end

def build
  SubscriberProofs::Builder
end

heading 'Defining a handler' do
  proof 'Generates a method on the handler class that meets the necessary signature for a handler method' do
    sut = build.subscriber

    sut.prove { respond_to? :handle_some_event }
  end
end

heading 'Triggering the handler method' do
  proof 'Runs the code defined in the handler block in the context of the instance of the handler class' do
    sut = build.subscriber
    event = fake

    sut.handle_some_event (event)

    sut.prove { handled?(event) }
  end
end
