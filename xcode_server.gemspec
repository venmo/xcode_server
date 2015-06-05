# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcode_server/version'

Gem::Specification.new do |spec|
  spec.name          = 'xcode_server'
  spec.version       = XcodeServer::VERSION
  spec.authors       = ['Sam Soffes', 'Mickey Reiss']
  spec.email         = ['sam@soff.es', 'mickeyreiss@gmail.com']

  spec.summary       = 'Xcode Bot client'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/venmo/xcode_server'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '>= 5.0'
  spec.add_development_dependency 'minitest-reporters'
end
