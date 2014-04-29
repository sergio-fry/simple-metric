# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_metric/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_metric"
  spec.version       = Simple::Metric::VERSION
  spec.authors       = ["Sergei O. Udalov"]
  spec.email         = ["sergei.udalov@gmail.com"]
  spec.summary       = %q{Store data-points, plot graph with Dygraph}
  spec.description   = %q{SimpleMetric is a Rails plugin offering easy solution for storing and plotting measurements for your app}
  spec.homepage      = "https://github.com/sergio-fry/simple-metric"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.1"
  spec.add_dependency "activesupport", ">= 3.1"
  spec.add_dependency "spliner", "~> 1.0.5"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
