# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vapor/version'

Gem::Specification.new do |spec|
  spec.name          = "vapor"
  spec.version       = Vapor::VERSION
  spec.authors       = ["Dunya Kirkali"]
  spec.email         = ["dunyakirkali@gmail.com"]

  spec.summary       = %q{Gem to communicate with the OwnCloud API}
  spec.description   = %q{Gem to communicate with the OwnCloud API}
  spec.homepage      = "https://github.com/hoppinger/vapor"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-rcov"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency "net_dav", "~> 0.5.0"
end
