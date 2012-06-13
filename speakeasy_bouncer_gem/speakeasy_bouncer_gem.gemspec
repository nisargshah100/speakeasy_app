# -*- encoding: utf-8 -*-
require File.expand_path('../lib/speakeasy_bouncer_gem/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nisarg Shah"]
  gem.email         = ["nisargshah100@gmail.com"]
  gem.description   = %q{Gem for talking to speakeasy bouncer}
  gem.summary       = %q{Tasks to bouncer}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "speakeasy_bouncer_gem"
  gem.require_paths = ["lib"]
  gem.version       = SpeakeasyBouncerGem::VERSION

  gem.add_dependency "faraday"
  gem.add_dependency "hashie"
end
