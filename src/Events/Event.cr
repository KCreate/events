require "./*"

module Events

  # Describes an event
  class Event

    # :nodoc:
    getter handlers
    @handlers = [] of Events::Handler

    # Add a new *handler* to the event
    #
    # Returns a proc that removes the handler from the event
    def add_handler(handler : Handler)
      @handlers << handler

      ->{
        remove_handler handler
      }
    end

    # Add a new *block* to the event
    #
    # This will create a new handler and pass it to #add_handler(handler)
    def add_handler(block : ->)
      handler = Events::Handler.new block
      add_handler handler
    end

    # Removes a *handler* from the event
    def remove_handler(handler : Handler)
      @handlers.delete handler
    end

    # Invoke all handlers
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
