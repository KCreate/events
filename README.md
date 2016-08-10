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


## Usage

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

## Contributing

1. Fork it ( https://github.com/kcreate/events/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [kcreate](https://github.com/kcreate) Leonard Schuetz - creator, maintainer
