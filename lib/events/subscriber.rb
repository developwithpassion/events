module Events
  module Subscriber
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def handle(event_name, &handler_block)
        handler_name = EventNaming::create_handler_name(event_name)
        self.instance_eval do
          define_method(handler_name) do |event|
            self.instance_exec(event, &handler_block)
          end
        end
      end
    end
  end
end
