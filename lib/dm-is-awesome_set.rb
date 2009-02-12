require 'pathname'
['dm-core', 'dm-adjust', 'dm-aggregates', 'dm-validations'].each do |dm_var|
  gem dm_var, '>=0.9.7'
  require dm_var
end
require Pathname(__FILE__).dirname.expand_path / 'dm-is-awesome_set' / 'is' / 'awesome_set.rb'