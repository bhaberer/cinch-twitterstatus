# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/twitterstatus/version'

Gem::Specification.new do |gem|
  gem.name          = 'cinch-twitterstatus'
  gem.version       = Cinch::Plugins::TwitterStatus::VERSION
  gem.authors       = ['Brian Haberer']
  gem.email         = ['bhaberer@gmail.com']
  gem.description   = %q{Cinch IRC bot Plugin that access the Twitter API to post the content of linked twitter statuses to the channel.}
  gem.summary       = %q{Cinch Plugin to post tweets to channel.}
  gem.homepage      = 'https://github.com/bhaberer/cinch-twitterstatus'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'coveralls', '~> 0.7'
  gem.add_development_dependency 'cinch-test', '~> 0.1', '>= 0.1.0'
  gem.add_dependency 'cinch', '~> 2'
  gem.add_dependency 'cinch-toolbox', '~> 1.1'
  gem.add_dependency 'twitter', '~> 5.16', '>= 5.16.0'
end
