# -*- coding: utf-8 -*-
require 'cinch'
require 'twitter'

module Cinch::Plugins
  class TwitterStatus
    include Cinch::Plugin

    self.help = 'Just link to a specific twitter status and I will post the content of that tweet.'

    listen_to :channel
    timer 15, method: :check_watched

    def initialize(*args)
      super
      if config
        Twitter.configure do |c|
          c.consumer_key =        config[:consumer_key]
          c.consumer_secret =     config[:consumer_secret]
          c.oauth_token =         config[:oauth_token]
          c.oauth_token_secret =  config[:oauth_secret]
        end

        if config[:watchers]
          @watched = Hash.new
          config[:watchers].each_pair do |chan, users|
            @watched[chan] = Hash.new
            users.each { |user| refresh_cache(chan, user) }
          end
        end
      end
    end

    def check_watched
      return unless @watched

      @watched.keys.each do |chan|
        @watched[chan].keys.each do |user|
          begin 
            # Just check the last tweet, if they are posting more than once
            # every timer tick I don't want to spam the channel. 
            tweet = Twitter::Client.new.user_timeline(user).first
            unless @watched[chan][user].include?(tweet.id)
              @watched[chan][user] << tweet.id
              
              msg = format_tweet(user, Twitter.status(tweet.id).text)
              Channel(chan).send msg unless msg.nil?
            end
            refresh_cache(chan, user)
          rescue Twitter::Error::NotFound
            debug "You have set an invalid or protected user (#{user}) to watch, please correct this error"
          end
        end
      end
    end

    def listen(m)
      urls = URI.extract(m.message, ["http", "https"])
      urls.each do |url|
        if url.match(/^https?:\/\/mobile|w{3}?\.?twitter\.com/)
          if tweet = url.match(/https?:\/\/mobile|w{3}?\.?twitter\.com\/?#?!?\/([^\/]+)\/statuse?s?\/(\d+)\/?/)
            msg = format_tweet(tweet[1], Twitter.status(tweet[2]).text)
            m.reply msg unless msg.nil?
          end
        end
      end
    rescue Twitter::Error::NotFound
      debug "User posted an invalid twitter status"
    rescue Twitter::Error::Forbidden
      debug "User attempted to post a Protected Tweet or you have not set valid Twitter credentials."
    end

    private

    def format_tweet(user, status)
      # Return blank if we didn't get a good user and status
      return if user.nil? || status.nil?

      # Scrub the tweet for returns so we don't have multilined responses.
      status.gsub!(/[\n]+/, " ") if status.match(/\n/)

      return "@#{user} tweeted \"#{status}\""
    end

    def refresh_cache(chan, user)
      @watched[chan][user] = []
      Twitter::Client.new.user_timeline(user).each do |tweet|
        @watched[chan][user] << tweet.id
      end
    rescue Twitter::Error::NotFound
      debug "You have set an invalid or protected user (#{user}) to watch, please correct this error"
    end
  end
end
