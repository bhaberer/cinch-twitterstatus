# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/twitterstatus/version'

Gem::Specification.new do |gem|
  gem.name          = "cinch-twitterstatus"
  gem.version       = Cinch::Twitterstatus::VERSION
  gem.authors       = ["Brian Haberer"]
  gem.email         = ["bhaberer@gmail.com"]
  gem.description   = %q{Cinch IRC bot Plugin that access the Twitter API to post the content of linked twitter statuses to the channel.}
  gem.summary       = %q{Cinch Plugin to post tweets to channel.}
  gem.homepage      = "https://github.com/bhaberer/cinch-twitterstatus"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'twitter', '4.6.2'
end
