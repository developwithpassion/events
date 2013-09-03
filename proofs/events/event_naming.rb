require_relative '../proofs_init'

title 'Event Naming'

module EventNamingProofs
  module Builder
    extend self

    module Other
      class SomeClass
      end
    end

    def sut
      ::Events::EventNaming
    end

    def event
      Other::SomeClass.new
    end
  end
end

def build
  EventNamingProofs::Builder
end

proof 'Event instances can be converted to an event name' do
  sut = build.sut 
  event = build.event

  result = sut.create_event_name_from_event(event)

  result.prove { eql? :some_class }
end

proof 'Event names can be converted to an event handler name' do
  sut = build.sut 
  event = build.event

  result = sut.create_handler_name("some_class")

  result.prove { eql? :handle_some_class }
end

proof 'Event instances can be converted to an event handler name' do
  sut = build.sut 
  event = build.event

  result = sut.create_handler_name(event)

  result.prove { eql? :handle_some_class }
end
