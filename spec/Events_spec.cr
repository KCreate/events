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
end
