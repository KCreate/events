require "./Events/*"

# Adds the @__events instance variable to the current class
module Events
  @__events = {} of String => Event
end

# Adds the `Event` class
module Events

  # All saved events and their callback-procs are stored in this instance variable
  getter __events
  @__events = {} of String => Event

  # Event
  #
  # Saves all callbacks for a given event
  # Also adds the functionality to invoke all methods
  class Event
    getter handlers

    @handlers = [] of ->

    # Add a new handler
    # Returns a proc that removes the handler from the event
    def add_handler(block)
      @handlers << block

      # Return a proc that removes the handler again
      ->{
        @handlers.delete block
      }
    end

    # Removes a handler from the event
    # You need to pass the exact same proc as you did for add_handler
    # This just uses the equality check performed by Array#delete
    def remove_handler(block)
      @handlers.delete block
    end

    # Invokes all handlers
    def invoke

      # Check if there are any handlers available
      if @handlers.size > 0
        @handlers.each do |handler|
          handler.call
        end
      end
    end
  end
end

# Adds public functions for adding, removing, invoking and listening events
module Events

  # Add an event with name *name*
  def add_event(name : String)
    @__events[name] = Event.new
  end

  # Removes an event by *name*
  def remove_event(name : String)
    @__events.delete name
  end

  # Invoke a given event by *name*
  def invoke_event(name : String)
    if event_exists name
      @__events[name].invoke
    end
  end

  # Add a handler to the event *name*
  # If the event doesn't exist, it will be created
  def on(name : String, &block : ->)
    if !event_exists name
      add_event name
    end

    @__events[name].add_handler block
  end

  # Checks if a given event with *name* exists
  def event_exists(name : String)
    @__events.has_key? name
  end
end
