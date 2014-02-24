# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/when_change/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record-when_change"
  spec.version       = ActiveRecord::WhenChange::VERSION
  spec.authors       = ["Zidni Mubarock"]
  spec.email         = ["zidmubarock@gmail.com"]
  spec.summary       = %q{Simple DSL to control callback attribute changed in ActiveRecord model}
  spec.description   = %q{Simple DSL to control callback attribute changed in ActiveRecord model}
  spec.homepage      = "http://barock.github.io/active_record-when_change"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "railties", "~> 4.0.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rr"
  spec.add_development_dependency "rake"
end
