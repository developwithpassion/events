require_relative '../proofs_init'

title 'Subscriber'

module SubscriberProofs
  module Builder
    extend self

    class SomeSubscriber
      include ::Events::Subscriber

      handle :some_event do |message|
        @event = message
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

heading 'Handlers' do
  proof 'Can determine whether they can handle an event' do
    sut = build.subscriber

    sut.prove { handles?(:some_event)}
  end

  proof 'Can handle an event' do
    sut = build.subscriber

    data = {}

    sut.handle_some_event(data)

    sut.prove { handled?(data)}
  end
end
