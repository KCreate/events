require "./Events/*"

# This is a module
module Events

  @__events = {} of String => Event

  # Event class
  # Keeps track of subscribers and invocations
  class Event
    getter name
    getter handlers

    @name : String
    @handlers = [] of ->

    # Create a new event, giving it a name
    def initialize(@name)
    end

    # Adds a handler to the event
    def add_handler(block)
      @handlers << block
    end

    # Invokes all currently registered handlers
    def invoke
      @handlers.each do |handler|
        handler.call
      end
    end
  end

  # Add an event with a name
  def add_event(name : String)
    @__events[name] = Event.new name
  end

  # Removes an event by it's name
  def remove_event(name : String)
    @__events.delete name
  end

  # Invoke a given event
  def invoke_event(name : String)
    if event_exists name
      @__events[name].invoke
    end
  end

  # Add a handler to an event
  # If the event doesn't exist, it will be created
  #
  # A handler should be a block receiving a string
  def on(name : String, &block : ->)
    if !event_exists name
      add_event name
    end

    @__events[name].add_handler block
  end

  # Checks if a given event exists
  def event_exists(name : String)
    @__events.has_key? name
  end
end
