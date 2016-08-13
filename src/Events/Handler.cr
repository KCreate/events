require "./*"

module Events

  # Abstract Handler
  abstract class Handler(T)

    # :nodoc:
    getter block
    @block : Proc(T)

    def initialize(@block)
    end

    # Run the handler
    def call(*args)
      @block.call *args
    end
  end

  # A regular Handler
  class RegularHandler < Handler(Nil)
  end
end
