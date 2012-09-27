# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic-pjax/version'

Gem::Specification.new do |gem|
  gem.name          = "newrelic-pjax"
  gem.version       = Newrelic::Pjax::VERSION
  gem.authors       = ["Mario Visic"]
  gem.email         = ["mario@mariovisic.com"]
  gem.description   = %q{Instrument PJAX requests for New Relic RPM}
  gem.summary       = %q{Adds additional helper methods to the newrelic_rpm gem to allow instrumentation of PJAX requests}
  gem.homepage      = "https://github.com/mariovisic/newrelic-pjax"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
