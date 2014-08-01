# -*- coding: utf-8 -*-
require 'cinch'
require 'spec_helper'
describe Cinch::Plugins::TwitterStatus do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(Cinch::Plugins::TwitterStatus,
                    { filename: '/dev/null',
                      watchers: { '#foo' => ['weirdo513'] },
                      consumer_key: ENV['CONSUMER_KEY'],
                      consumer_secret: ENV['CONSUMER_SECRET'],
                      oauth_token: ENV['OAUTH_TOKEN'],
                      oauth_secret: ENV['OAUTH_SECRET'] })
    @status =
      { normal: 'https://twitter.com/weirdo513/status/344186643609174016',
        protected: 'https://twitter.com/brewtopian/status/68071618055901184',
        invalid: 'https://twitter.com/weirdo513/status/3INVALI643609174016' }
  end

  describe "Twitter Link Parsing" do
    it 'should return the text of the tweet when linked in the channel' do
      msg = get_replies(make_message(@bot, @status[:normal],
                                     { channel: '#foo', nick: 'bar' })).first
      expect(msg.text).to eq('@weirdo513 tweeted "HOW IS THAT MIC STILL ON JESUS"')
    end

    it 'should not return any text if the status is invalid' do
      msg = get_replies(make_message(@bot, @status[:invalid],
                                     { channel: '#foo', nick: 'bar' }))
      expect(msg).to be_empty
    end

    it 'should not return any text if the status is protected' do
      msg = get_replies(make_message(@bot, @status[:protected],
                                     { channel: '#foo', nick: 'bar' }))
      expect(msg).to be_empty
    end

    it 'should not run without credentials set' do
      bot = make_bot(Cinch::Plugins::TwitterStatus)
      msg = get_replies(make_message(bot, @status[:normal],
                                     { channel: '#foo', nick: 'bar' }))
      expect(msg).to be_empty
    end
  end

  describe "Watchers" do
    # FIXME: cinch-test does not allow timers to function
    it 'should not post tweets that already existed when the bot was started' do
      sleep 20
      get_replies(make_message(@bot, @status[:normal],
                               { channel: '#foo', nick: 'bar' }))
    end
  end
end
