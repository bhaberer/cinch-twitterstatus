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
      { normal: 'https://twitter.com/_bhaberer/status/344186643609174016',
        protected: 'https://twitter.com/brewtopian/status/68071618055901184',
        invalid: 'https://twitter.com/_bhaberer/status/3INVALI643609174016',
        multiline: 'https://twitter.com/Peeardee/status/502209346038951937'}
  end

  describe "Twitter Link Parsing" do
    it 'should return the text of the tweet when linked in the channel' do
      msg = get_replies(make_message(@bot, @status[:normal],
                                     { channel: '#foo', nick: 'bar' })).first
      expect(msg.text).to eq('@weirdo513 tweeted "HOW IS THAT MIC STILL ON JESUS"')
    end

    it 'should return the text of the tweet when linked in the channel' do
      msg = get_replies(make_message(@bot, @status[:multiline],
                                     { channel: '#foo', nick: 'bar' })).first
      expect(msg.text).to eq('@Peeardee tweeted "Dear My RP Group, I *will* be working on the Enforcer schedule during our Call of Cthulhu session tonight. Will make frequent sanity rolls."')
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
end
