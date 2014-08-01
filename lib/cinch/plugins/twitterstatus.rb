# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/toolbox'
require 'twitter'

module Cinch
  module Plugins
    # Cinch Plugin to post twitter statuses
    class TwitterStatus
      include Cinch::Plugin

      self.help = 'Just link to a specific twitter status and I will ' \
                  'post the content of that tweet.'

      listen_to :channel

      def initialize(*args)
        super
        @client = twitter_client
      end

      def listen(m)
        Cinch::Toolbox.extract_urls(m.message).each do |url|
          next unless url.match(%r(^https?://mobile|w{3}?\.?twitter\.com/))
          msg = format_tweet(url)
          m.reply msg unless msg.nil?
        end
      rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
        debug 'User posted an invalid twitter status'
      end

      def format_tweet(url)
        # Parse the url and get the relevant data
        user, status = parse_twitter_url(url)

        # Return blank if we didn't get a good user and status
        return if user.nil? || status.nil?

        tweet_text(user, status)
      end

      def tweet_text(user, status)
        # Scrub the tweet for returns so we don't have multilined responses.
        status.gsub!(/[\n]+/, ' ') if status.match(/\n/)
        "@#{user} tweeted \"#{status}\""
      end

      private

      def parse_twitter_url(url)
        tweet_id = url[%r{statuse?s?/(\d+)/?}, 1]
        user = url[%r{/?#?!?/([^\/]+)/statuse?s?}, 1]
        [user, @client.status(tweet_id).text]
      end

      def twitter_client
        Twitter::REST::Client.new do |c|
          c.consumer_key = config[:consumer_key]
          c.consumer_secret = config[:consumer_secret]
          c.access_token = config[:access_token]
          c.access_token_secret = config[:access_secret]
        end
      end
    end
  end
end
