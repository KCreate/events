[![Build Status](https://travis-ci.org/KCreate/events.svg?branch=master)](https://travis-ci.org/KCreate/events)

# Events

Super basic event emitter written for crystal-lang.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  events:
    github: kcreate/events
    branch: master
```


## Example

Just include the module inside any classes you want to have access to the event methods

```crystal
require "events"

# Some class
class Person
  include Events

  def initialize
    add_event "fart"
  end

  def fart
    invoke_event "fart"
  end
end

leonard = Person.new
leonard.on "fart", do
  puts "daaamn"
end
leonard.fart
```

You should see "daaamn" pop up in your console

## Usage

The [test suite](spec/Events_spec.cr) has all the examples you need. I usually forget to update the README so just look there.

You first need a class that will emit some events. Add the module to your class like this:
```crystal
class Person
  include Events
end
```

You should add all your events inside your initialize function to prevent unexpected behaviour. Use *add_event* for this.
```crystal
class Person
  include Events

  def initialize
    add_event "wakeup"
    add_event "sleep"
  end

  def wakeup
    invoke_event "wakeup"
  end

  def gotosleep
    invoke_event "sleep"
  end

  # ... The rest of your class
end
```

Similarly you can remove an event using *remove_event*. I don't know why you'd want to remove an event, but you can.
```crystal
class Person
  include Events

  def initialize
    add_event "wakeup"
    add_event "sleep"
  end

  def wakeup
    invoke_event "wakeup"
  end

  def gotosleep

    # This first invokes the event and deletes it afterwards

    invoke_event "sleep"
    remove_event "sleep"
  end
end
```

You can subscribe to these events from the outside like this:
```crystal
class Person
  ...
end

leonard = Person.new

leonard.on "wakeup" do
  puts "leonard woke up"
end

leonard.on "sleep" do
  puts "leonard went to sleep"
end
```

If you now call the *wakeup* and *gotosleep* functions,
```crystal
leonard.gotosleep
leonard.wakeup
```

This will be the output in your console
```sh
leonard went to sleep
leonard woke up
```

Calling the *on* function will add your handler to the event, but also return a proc that removes the handler from the event again.
This means you can do stuff like this:
```crystal
sleephandler = leonard.on "sleep" do
    puts "going to sleep"
end

leonard.gotosleep # going to sleep
leonard.gotosleep # going to sleep

sleephandler.call # removing the handler

leonard.gotosleep # ... nothing will be printed
```

## Test

Run `crystal spec` to run the test suite.

## Contributing

1. Fork it ( https://github.com/kcreate/events/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Make sure your changes don't break anything (crystal spec)
5. Push to the branch (git push origin my-new-feature)
6. Create a new Pull Request

## Contributors

- [kcreate](https://github.com/kcreate) Leonard Schuetz - creator, maintainer
