# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sbconstants/version'

Gem::Specification.new do |gem|
  gem.name          = "sbconstants"
  gem.version       = SBConstants::VERSION
  gem.authors       = ["Paul Samuels", "Orta Therox"]
  gem.email         = ["paulio1987@gmail.com", "orta.therox@gmail.com"]
  gem.description   = %q{Generate constants from storyboards in objc and swift.}
  gem.summary       = %q{Generate constants from storyboards in Objective-C and Swift.}
  gem.homepage      = "https://github.com/paulsamuels/SBConstants"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
