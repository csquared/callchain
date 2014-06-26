# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'callchain/version'

Gem::Specification.new do |spec|
  spec.name          = "callchain"
  spec.version       = Callchain::VERSION
  spec.authors       = ["csquared"]
  spec.email         = ["christopher.continanza@gmail.com"]
  spec.summary       = %q{Simple, composable call chains}
  spec.description   = %q{Simple, composalbe call chains}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
