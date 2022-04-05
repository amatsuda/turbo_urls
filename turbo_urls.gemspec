# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'turbo_urls/version'

Gem::Specification.new do |spec|
  spec.name          = "turbo_urls"
  spec.version       = TurboUrls::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Named URL helper cache for Rails'
  spec.description   = 'TurboUrl aggressively caches Named URL helper turbo booster for Rails'
  spec.homepage      = 'https://github.com/amatsuda/turbo_urls'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rails', '~> 4.2.0'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'test-unit-rails'
  spec.add_development_dependency 'sqlite3', '< 1.4'
  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'allocation_tracer'
  spec.add_development_dependency 'byebug'
end
