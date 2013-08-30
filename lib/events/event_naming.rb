module Events
  module EventNaming
    extend self

    def create_handler_name(event_or_event_name)
      return create_handler_name_from_name(event_or_event_name.to_s) if [String, Symbol].include?(event_or_event_name.class)
      event_name = create_event_name_from_event(event_or_event_name) 
      return create_handler_name_from_name(event_name) 
    end

    def create_handler_name_from_name(name)
      "handle_#{name.to_s}".to_sym
    end

    def create_event_name_from_event(event)
      class_name = event.class.name

      event_name = class_name.split("::").last
      event_name[0] = event_name[0].downcase
      event_name = event_name.gsub(/([A-Z])/) do |match|
        "_#{match.downcase}"
      end
      event_name.to_sym
    end
  end
end
