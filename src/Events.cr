require "./Events/*"

# When included into a class, this adds the functionality to subscribe to, invoke and manage events and their corresponding handlers
#
# You can also use this as a global event manager
#
# Usage example:
# ```
# require "events"
#
# # Some class
# class Person
#   include Events
#
#   def initialize
#     add_event "fart"
#   end
#
#   def fart
#     invoke_event "fart"
#   end
# end
#
# leonard = Person.new
# leonard.on "fart", do
#   puts "daaamn"
# end
# leonard.fart
# ```
#
# You don't _have_ to explicitly add every event via *add_event*,
# but it's best-practice to register all events in your initialize function so you can see which class has which events
#
# You can also pass an array to *add_event* to batch-register events
module Events

  # All saved events and their callback-procs are stored in this instance variable
  @__events = {} of String => Event

  # :nodoc:
  def __events
    @__events
  end

  # Saves all callbacks for a given event
  #
  # Also adds the functionality to invoke all methods
  class Event
    getter handlers

    @handlers = [] of ->

    # Add a new handler
    #
    # Returns a proc that removes the handler from the event
    def add_handler(block)
      @handlers << block

      # Return a proc that removes the handler again
      ->{
        @handlers.delete block
      }
    end

    # Removes a handler from the event
    #
    # You need to pass the exact same proc as you did for add_handler
    #
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

  # Add an event with a *name*
  #
  # If there are some handlers for that event, this won't have any effect
  #
  # This method is actually purely optional, as it will be called anyway when someone adds a handler and the event doesn't exist
  def add_event(name : String)

    # If the event already exists, it is assumed that is has some handlers
    # Simply ignore the call
    if !event_exists name
      @__events[name] = Event.new
    end
  end

  # Add an event for each string inside *eventlist*
  #
  # ```
  # add_event ["event1", "event2", "event3"]
  #
  # # Is the same as writing:
  #
  # add_event "event1"
  # add_event "event2"
  # add_event "event3"
  # ```
  def add_event(eventlist : Array(String))
    eventlist.each do |name|
      add_event name
    end
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

  # Invoke a list of events, in a specified order
  #
  # ```
  # invoke_event ["event1", "event2", "event3"]
  #
  # # Is the same as writing:
  #
  # invoke_event "event1"
  # invoke_event "event2"
  # invoke_event "event3"
  # ```
  def invoke_event(eventlist : Array(String))
    eventlist.each do |name|
      invoke_event name
    end
  end

  # Add a handler to the event *name*
  #
  # If the event doesn't exist, it will be created
  def on(name : String, &block : ->)
    if !event_exists name
      add_event name
    end

    @__events[name].add_handler block
  end

  # Add a handler to all specified events
  #
  # If the event doesn't exist, it will be created
  #
  # ```
  # on ["event1", "event2", "event3"] do
  #   puts "stuff"
  # end
  #
  # # Is the same as writing:
  #
  # on "event1" do
  #   puts "stuff"
  # end
  # on "event2" do
  #   puts "stuff"
  # end
  # on "event3" do
  #   puts "stuff"
  # end
  # ```
  def on(eventlist : Array(String), &block : ->)
    removeHandlers = [] of ->
    eventlist.each do |name|
      removeHandlers << on(name, &block)
    end
    removeHandlers
  end

  # Checks if a given event with *name* exists
  def event_exists(name : String)
    @__events.has_key? name
  end
end
