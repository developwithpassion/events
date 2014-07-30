module Events
  module Subscriber
    def self.included(base)
      base.send :include, EventNaming
      base.extend ClassMethods
    end

    def handles?(event_name)
      handler_name = create_handler_name(event_name)
      self.respond_to?(handler_name)
    end

    module ClassMethods
      def handle(event_name, &block)
        name = "handle_#{event_name}"

        instance_eval do 
          define_method name do |message|
            self.instance_exec(message, &block)
          end
        end
      end
    end
  end
end
