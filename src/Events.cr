require "./Events/*"

module Events

  # :nodoc:
  getter __events
  @__events = {} of String => RegularEvent

  # Registers a new event, gives it a *name* and returns it.
  # If the event already exists, it's returned
  def register_event(name)
    name = to_string name

    if !event_exists name
      @__events[name] = RegularEvent.new name
    end

    @__events[name]
  end

  def register_event(list : Array(_))
    list.each do |name|
      register_event name
    end
  end

  # Unregisters the the event given by *name*
  def unregister_event(name)
    name = to_string name

    if event_exists name
      @__events.delete name
    end
  end

  # Invoke an event given by *name*,
  # returns an Int32 with the amount of handlers run,
  # false if the event didn't exist
  def invoke_event(name, *args)
    name = to_string name

    if !event_exists name
      false
    end

    @__events[name].invoke *args
  end

  def invoke_event(list : Array(_), *args)
    calledTimes = [] of Int32

    list.each_with_index do |name, index|
      calledTimes << invoke_event name, *args
    end

    calledTimes
  end

  # Add a *block* to the given *event*,
  # returns a proc that removes the *block*
  #
  # Creates the event if it doesn't exist already
  def on(name, &block )
    name = to_string name

    if !event_exists name
      register_event name
    end

    @__events[name].add_handler block
  end

  def on(list : Array(_), &block)
    removeHandlers = [] of ->

    list.each do |name|
      removeHandlers << on name, &block
    end

    ->{
      removeHandlers.each &.call
    }
  end

  def clear_handlers(name)
    name = to_string name

    if event_exists name
      @__events[name].clear_handlers
    end
  end

  # Removes a *block* from an event given by *name*
  def remove_handler(name, &block)
    name = to_string name

    if event_exists name
      @__events[name].remove_handler block
    end
  end

  # Returns the argument as a string
  private def to_string(arg)
    arg.to_s
  end

end
