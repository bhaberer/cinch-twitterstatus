# -*- coding: utf-8 -*-
require 'cinch'
require 'twitter'

module Cinch::Plugins
  class TwitterStatus
    include Cinch::Plugin

    self.help = 'Just link to a specific twitter status and I will post the content of that tweet.'

    listen_to :channel

    def initialize(*args)
      super
      if config
        Twitter.configure do |c|
          c.consumer_key = config[:consumer_key]
          c.consumer_secret = config[:consumer_secret]
          c.oauth_token = config[:oauth_token]
          c.oauth_token_secret = config[:oauth_secret]
        end
      else
        debug "You have not set your Twitter credentials, please do so!"
      end
    end

    def listen(m)
      urls = URI.extract(m.message, ["http", "https"])
      urls.each do |url|
        if url.match(/^https?:\/\/mobile|w{3}?\.?twitter\.com/)
          twitter = {}
          if tweet = url.match(/https?:\/\/mobile|w{3}?\.?twitter\.com\/?#?!?\/([^\/]+)\/statuse?s?\/(\d+)\/?/)
            unless config[:twitter] == false
              twitter[:status] = Twitter.status(tweet[2]).text
              twitter[:status].gsub!(/[\n]+/, " ");
              twitter[:user] = tweet[1]
              m.reply "@#{twitter[:user]} tweeted \"#{twitter[:status]}\""
              # FIXME Make this cinch-linkstumble aware at some point!
              # post_quote(twitter[:status], "<a href='#{url}'>#{twitter[:user]} on Twitter</a>")
            end
          end
        end
      end
    end
  end
end
