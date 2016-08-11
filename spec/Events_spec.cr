require "./spec_helper"

# Test class we are working with to test events
class Test
  include Events
end

# Basic functionality tests
describe Events do
  it "Adds a callback to the list" do
    test = Test.new
    test.add_event "something"
    test.on "something" do
      # Ignore me
    end

    # Check if the event contains a handler
    test.__events["something"].handlers.size.should eq(1)
  end

  it "Runs a single handler" do

    # This should equal true after the test
    wasCalled = false

    test = Test.new
    test.add_event "something"
    test.on "something" do
      wasCalled = true
    end
    test.invoke_event "something"

    wasCalled.should eq(true)
  end

  it "Runs multiple handlers" do

    # Keep track of 3 handlers
    calledHandlers = [false, false, false]

    test = Test.new
    test.add_event "something"
    test.on "something" do
      calledHandlers[0] = true
    end
    test.on "something" do
      calledHandlers[1] = true
    end
    test.on "something" do
      calledHandlers[2] = true
    end
    test.invoke_event "something"

    # All handlers shoul've been called
    calledHandlers.should eq([true, true, true])
  end

  it "Deletes a single handler from an event" do

    # Keep track of 3 handlers
    calledHandlers = [false, false, false]

    test = Test.new
    test.add_event "something"
    test.on "something" do
      calledHandlers[0] = true
    end
    handler2 = test.on "something" do
      calledHandlers[1] = true
    end
    test.on "something" do
      calledHandlers[2] = true
    end

    # Remove the second handler
    handler2.call

    # Invoke all remaining handlers
    test.invoke_event "something"

    # All handlers, except handler 2, should've been called
    calledHandlers.should eq([true, false, true])
  end

  it "Events can be called with no handlers receiving them" do

    # Keep track of 1 handler
    timesCalled = 0

    test = Test.new
    test.add_event "something"
    removeHandler = test.on "something" do
      timesCalled += 1
    end
    test.invoke_event "something"
    test.invoke_event "something"

    removeHandler.call

    test.invoke_event "something"

    timesCalled.should eq(2)
  end

  it "add_event can add multiple events" do

    test = Test.new
    test.add_event ["this", "is", "a", "test"]

    test.__events.keys.should eq(["this", "is", "a", "test"])
  end

  it "invoke_event can invoke multiple events, in the correct order" do

    # The initial string
    initial = "Hello World"
    tmp = ""
    result = "b84ace3d700a5e778c5e07da8ea3745f"

    test = Test.new
    test.add_event ["event1", "event2", "event3"]
    test.on "event1" do
      tmp = Crypto::MD5.hex_digest initial
    end
    test.on "event2" do
      tmp = Crypto::MD5.hex_digest tmp
    end
    test.on "event3" do
      tmp = Crypto::MD5.hex_digest tmp
    end
    test.invoke_event ["event1", "event2", "event3"]

    tmp.should eq(result)
  end

  it "on can add handlers to multiple events" do

    # Keep track how often each handler was called
    handlersCalled = [0, 0, 0]

    test = Test.new
    test.add_event ["event1", "event2", "event3"]
    test.on ["event1", "event2"] do
      handlersCalled[0] += 1
      handlersCalled[1] += 1
    end
    test.on ["event2", "event3"] do
      handlersCalled[1] += 1
      handlersCalled[2] += 1
    end
    test.invoke_event ["event1", "event2", "event3"]

    handlersCalled.should eq([2, 4, 2])
  end

  it "batch-adding handlers returns an array of procs to return the handlers" do

    test = Test.new
    test.add_event ["event1", "event2"]
    removeHandlers = test.on ["event1", "event2"] do
      # ignore
    end
    removeHandlers[0].call

    test.__events["event1"].handlers.size.should eq(0)
  end
end
