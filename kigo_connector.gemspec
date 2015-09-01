# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "kigo_connector"
  spec.version       = "0.1.0"
  spec.authors       = ["Diego Fernandez Fernandez"]
  spec.email         = ["diego.fernandez.fernandez@gmail.com"]

  spec.summary       = %q{Provides an object oriented wrapper over the Kigo API.}
  spec.description = <<-EOF
  Rake is a Make-like program implemented in Ruby. Tasks and
  dependencies are specified in standard Ruby syntax.
  EOF
  spec.homepage      = "https://github.com/BeMate/kigo_connector"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ["lib"]

  # Only with ruby 2.X
  spec.required_ruby_version = '~> 2'
  spec.add_runtime_dependency "typhoeus", "~> 0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "vcr", "~> 0"
  spec.add_development_dependency "webmock", "~> 0"
  spec.add_development_dependency "rspec", "~> 0"
  spec.add_development_dependency "pry", "~> 0"
  spec.add_development_dependency "pry-byebug", "~> 0"
  spec.add_development_dependency "pry-doc", "~> 0"
  spec.add_development_dependency "pry-docmore", "~> 0"
  spec.add_development_dependency "pry-stack_explorer", "~> 0"
  spec.add_development_dependency "pry-rescue", "~> 0"
  spec.add_development_dependency "bond", "~> 0"
  spec.add_development_dependency "jist", "~> 0"
  spec.add_development_dependency "yard", "~> 0"
end
