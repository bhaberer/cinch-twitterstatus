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
          c.consumer_key =        config[:consumer_key]
          c.consumer_secret =     config[:consumer_secret]
          c.oauth_token =         config[:oauth_token]
          c.oauth_token_secret =  config[:oauth_secret]
        end
      end
    end

    def listen(m)
      urls = URI.extract(m.message, ["http", "https"])
      urls.each do |url|
        if url.match(/^https?:\/\/mobile|w{3}?\.?twitter\.com/)
          if tweet = url.match(/https?:\/\/mobile|w{3}?\.?twitter\.com\/?#?!?\/([^\/]+)\/statuse?s?\/(\d+)\/?/)
            status = Twitter.status(tweet[2]).text
            status.gsub!(/[\n]+/, " ") if status.match(/\n/)
            user = tweet[1]
            unless user.nil? || status.nil?
              m.reply "@#{user} tweeted \"#{status}\""
            end
          end
        end
      end
    rescue Twitter::Error::NotFound
      debug "User posted an invalid twitter status"
    rescue Twitter::Error::Forbidden
      debug "User attempted to post a Protected Tweet"
    rescue Twitter::Error::BadRequest
      debug "You have not set valid Twitter credentials, please see documentation"
    end
  end
end
