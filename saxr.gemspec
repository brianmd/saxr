# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saxr/version'

Gem::Specification.new do |spec|
  spec.name          = "saxr"
  spec.version       = Saxr::VERSION
  spec.authors       = ["Brian Murphy-Dye"]
  spec.email         = ["brian@murphydye.com"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'ox'

  spec.add_development_dependency 'bundler', '>= 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
end
