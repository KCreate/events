require "./*"

module Events

  # Describes a single handler
  class Handler

    def initialize(@block : ->)
    end

    # Run the saved handler
    def call
      @block.call
    end
  end
end
