# XcodeServer

Ruby library for working with Xcode Server and Xcode Bots.

> **Note:** This library uses an undocumented API within Xcode Bots and is not yet fully featured.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'xcode_server'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcode_server


## Usage

First, you need to initialize a server:

``` ruby
# Initialize a server with its host or IP
server = XcodeServer.new('10.0.1.2')
#=> #<XcodeServer::Server @host="10.0.1.2", @scheme="https">

# List the bots running on the server
server.bots
#=> [#<XcodeServer::Bot...

# Create a new bot
server.create_bot(...)

# Destroy a bot
server.destroy_bot(bot_id)
#=> true
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome [on GitHub](https://github.com/venmo/xcode_server).


## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

