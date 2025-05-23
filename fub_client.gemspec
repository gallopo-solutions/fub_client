# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fub_client/version'

Gem::Specification.new do |spec|
  spec.name          = "fub_client"
  spec.version       = FubClient::VERSION
  spec.authors       = ["Kyoto Kopz", "Connor Gallopo"]
  spec.email         = ["connor.gallopo@me.com"]

  spec.summary       = 'Ruby client for Follow Up Boss API http://www.followupboss.com'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/gallopo-solutions/fub_client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "her", "~> 1.1.1"
  spec.add_dependency "faraday", "~> 1.10.3"
  spec.add_dependency "facets", "~> 3.1.0"
  spec.add_dependency "multi_json", "~> 1.15.0"
  spec.add_dependency "activesupport", "~> 7.1.0"
  spec.add_dependency "activemodel", "~> 7.1.0"
  spec.add_dependency "tzinfo", "~> 2.0.6"
  spec.add_dependency "logger"
  # Developemnt
  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "dotenv", '>= 2.8.1'
  spec.add_development_dependency "vcr", '>= 6.1.0'
  spec.add_development_dependency "webmock", '>= 3.18.1'
  spec.add_development_dependency "pry", ">= 0.14.2"
end
