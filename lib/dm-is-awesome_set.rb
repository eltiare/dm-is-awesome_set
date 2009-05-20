require 'pathname'
['dm-core', 'dm-adjust', 'dm-aggregates', 'dm-validations'].each do |dm_var|
  require dm_var
end
require Pathname(__FILE__).dirname.expand_path / 'dm-is-awesome_set' / 'is' / 'awesome_set.rb'