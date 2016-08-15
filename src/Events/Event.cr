require "./*"

module Events

  # Abstract Event
  abstract class Event(H)

    # :nodoc:
    getter handlers
    getter name

    @handlers = [] of H
    @name : String

    def initialize(@name)
    end

    # Add a new *handler* to the event
    #
    # Returns a proc that removes the handler from the event
    def add_handler(handler : H)
      @handlers << handler

      ->{
        remove_handler handler
      }
    end

    # Add a new *block* to the event
    #
    # Returns a proc that removes the handler from the event
    def add_handler(block : ->)
      handler = H.new block
      @handlers << handler

      ->{
        remove_handler handler
      }
    end

    # Removes a *handler* from the event
    private def remove_handler(handler : H)
      @handlers.delete handler
    end

    # Invoke all handlers
    def invoke(*args)

      # Check if there are any handlers available
      if @handlers.size > 0
        @handlers.each do |handler|
          handler.call *args
        end
      end

      # Return the amount of handlers called
      @handlers.size
    end
  end

  # Defines an event which receives a SimpleHandler
  class RegularEvent < Event(RegularHandler)
  end
end
