# -*- encoding: utf-8 -*-
require File.expand_path('../lib/speakeasy_on_tap/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel Kaufman"]
  gem.email         = ["daniel.garrett.kaufman@gmail.com"]
  gem.description   = %q{Provides methods to publish events to redis queue}
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "speakeasy_on_tap"
  gem.require_paths = ["lib"]
  gem.version       = SpeakeasyOnTap::VERSION

  gem.add_dependency "redis"
end
