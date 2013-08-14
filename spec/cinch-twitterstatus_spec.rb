# -*- coding: utf-8 -*-
require 'cinch'
require 'spec_helper'
describe Cinch::Plugins::TwitterStatus do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(Cinch::Plugins::TwitterStatus, 
                    { filename:        '/dev/null',
                      hostname:        'marvintesting.tumblr.com',
                      consumer_key:    ENV['CONSUMER_KEY'],
                      consumer_secret: ENV['CONSUMER_SECRET'],
                      oauth_token:     ENV['OAUTH_TOKEN'],
                      oauth_secret:    ENV['OAUTH_SECRET'] })
  end

  it 'should return the texof e when linked in the channel' do
    get_replies(make_message(@bot, 'https://twitter.com/weirdo513/status/344186643609174016', 
                             { channel: '#foo', nick: 'bar' })).
      first.text.should == "@weirdo513 tweeted \"HOW IS THAT MIC STILL ON JESUS\""
  end

  it 'should not return any text if the status is invalid' do
    get_replies(make_message(@bot, 'https://twitter.com/weirdo513/status/3INVALI643609174016', 
                             { channel: '#foo', nick: 'bar' })).
      should be_empty
  end

  it 'should not return any text if the status is protected' do
    get_replies(make_message(@bot, 'https://twitter.com/brewtopian/status/68071618055901184', 
                             { channel: '#foo', nick: 'bar' })).
      should be_empty
  end

  it 'should not run without credentials set' do
    bot = make_bot(Cinch::Plugins::TwitterStatus)
    get_replies(make_message(bot, 'https://twitter.com/weirdo513/status/344186643609174016',
                             { channel: '#foo', nick: 'bar' }))
  end
end

