# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'areilayout/version'

Gem::Specification.new do |spec|
  spec.name          = "areilayout"
  spec.version       = Areilayout::VERSION
  spec.authors       = ["cobachie"]
  spec.email         = ["chie.kobayashi@avasys.jp"]
  spec.summary       = %q{Write a short summary. Required.}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = "https://github.com/cobachie/areilayout"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'thor', '~> 0.18', '>= 0.18.1'
  spec.add_runtime_dependency 'activerecord'
  spec.add_runtime_dependency 'mysql2'
  spec.add_runtime_dependency 'rubyzip'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
