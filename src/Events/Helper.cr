require "./*"

module Events

  # Check if an event with *name* exists
  def event_exists(name : String)
    @__events.has_key? name
  end
end
