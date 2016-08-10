require "./spec_helper"

class Test
  include Events

  def initialize
    add_event "something"
  end

  def doSomething
    invoke_event "something"
  end
end

describe Events do
  it "Runs the callback" do

    wasCalled = false

    test = Test.new
    test.on "something", do
      wasCalled = true
    end
    test.doSomething

    wasCalled.should eq(true)
  end
end
