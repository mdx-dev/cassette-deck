# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'cassette_deck/version'

Gem::Specification.new do |spec|
  spec.name          = 'cassette-deck'
  spec.version       = CassetteDeck::VERSION
  spec.authors       = ['Robin Curry']
  spec.email         = ['robin.curry@gmail.com']
  spec.description   = %q{Cassette Deck}
  spec.summary       = %q{Cassette Deck provides Rack middleware for playing pre-recorded vcr cassettes for matching requests.}
  spec.homepage      = 'https://github.com/mdx-dev/cassette-deck'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = []
  spec.test_files    = `git ls-files -- {spec}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'vcr', '~> 2.9'
  spec.add_runtime_dependency 'oj', '~> 2.9'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec', '~> 2.0'
end
