# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/pr/version'

Gem::Specification.new do |spec|
  spec.name          = 'git-pr'
  spec.version       = Git::Pr::VERSION
  spec.authors       = ['Nikolay Sturm']
  spec.email         = ['github@erisiandiscord.de']
  spec.description   = %q{git-pr facilitates GitHub pull requests}
  spec.summary       = %q{facilitates GitHub pull requests}
  spec.homepage      = 'https://github.com/nistude/git-pr'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'octokit', '~> 2.6'
  spec.add_runtime_dependency 'virtus', '~> 1.0'
end
