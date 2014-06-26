# CallChain

Simple, composable pipelines with `::call` and `::use`

[![Build Status](https://travis-ci.org/csquared/callchain.svg?branch=master)

## Installation

Add this line to your application's Gemfile:

    gem 'callchain'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install callchain

## Usage

Individual objects, lambdas, or modules do work with `::call(object)`

Compose a CallChain with the `::use` method

Compose a CallChain of call chains because it exports `::call(object)`

### Example: Class/Module names define `::call`

```ruby
  class PlanScoper
    def self.call(thing)
      scope_the_thing(thing)
      thing
    end
  end

  module Quantizer
    def self.call(thing)
      quantize_the_thing(thing)
      thing
    end
  end

  class Pricer
    extend CallChain
    use PlanScoper, Quantizer, AppGrouper
    use UserGrouper
  end

  statement = Statement.new
  Pricer.call(statement)
```

### Example: lambda-friendly

```ruby
  class Debugger
    extend CallChain
    use lambda { |thing| p thing; thing }
  end

  Debugger.call(Object.new)
```

### Example: composable
```ruby
  class CompositeCallChain
    extend CallChain
    use Debugger
  end

  CompositeCallChain.call(Object.new)
```

## CallChain::bind

```ruby
  class WrapToI
    extend CallChain
    use CallChain[:to_i]
  end

  WrapToI.call('1')
  # => 1
```

```ruby
  class WrapToI
    extend CallChain
    use CallChain.bind(:+, 1)
  end

  WrapToI.call(1)
  # => 2
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/callchain/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
