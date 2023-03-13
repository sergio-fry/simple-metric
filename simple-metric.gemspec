lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_metric/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_metric'
  spec.version       = SimpleMetric::VERSION
  spec.authors       = ['Sergei O. Udalov']
  spec.email         = ['sergei.udalov@gmail.com']
  spec.summary       = 'Store data-points, plot graph with Dygraph'
  spec.description   = 'SimpleMetric is a Rails plugin offering easy solution for storing and plotting measurements for your app'
  spec.homepage      = 'https://github.com/sergio-fry/simple-metric'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'activesupport', '>= 3.1'
  spec.add_dependency 'railties', '>= 3.1'
  spec.add_dependency 'spliner', '~> 1.0.5'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
