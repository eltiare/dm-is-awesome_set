# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-is-awesome_set/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = [ 'Jeremy Nicoll', 'David Haslem', 'Martin Gamsjaeger (snusnu)' ]
  gem.email       = [ 'gamsnjaga@gmail.com', 'jnicoll@gnexp.com' ]
  gem.summary     = "A library that lets any DataMapper model act like a nested set."
  gem.description = gem.summary
  gem.homepage    = "http://github.com/snusnu/dm-is-awesome_set"

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README]

  gem.name          = "dm-is-awesome_set"
  gem.require_paths = [ "lib" ]
  gem.version       = DataMapper::Is::AwesomeSet::VERSION

  gem.add_runtime_dependency('dm-core',            '~> 1.2')
  gem.add_runtime_dependency('dm-validations',     '~> 1.2')
  gem.add_runtime_dependency('dm-adjust',          '~> 1.2')
  gem.add_runtime_dependency('dm-aggregates',      '~> 1.2')
  gem.add_runtime_dependency('dm-transactions',    '~> 1.2')

  gem.add_development_dependency('dm-constraints', '~> 1.2')
  gem.add_development_dependency('rake',           '~> 0.9.2')
  gem.add_development_dependency('rspec',          '~> 1.3.2')
end
