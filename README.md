# Cinch::TwitterStatus

Posts the content of a linked Tweet to the channel.

## Installation

Add this line to your application's Gemfile:

    gem 'cinch-twitterstatus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-twitterstatus

## Usage

For the gem to work alll you will need to is add the gem to your plugins:
    @bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [ Cinch::Plugins::TwitterStatus]
      end
    end

And, acquire Twitter credentials. They are simple to acquire, see https://dev.twitter.com/apps/new

Once you have said credentials you will need to pass them to the Plugin's config like so:

    c.plugins.options[Cinch::Plugins::TwitterStatus] = { :consumer_key    => 'consumer_key',
                                                         :consumer_secret => 'consumer_secret',
                                                         :oauth_token     => 'oauth_token',
                                                         :oauth_secret    => 'oauth_secret' }

Then post a link to a specific tweet and the bot should post the content of said tweet to the channel.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
