require 'rubygems'
require 'rake/gempackagetask'

GEM_NAME = 'dm-is-awesome_set'

spec = Gem::Specification.new do |s|
  s.rubyforge_project = GEM_NAME
  s.name = GEM_NAME
  s.version = "0.10.0"
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = "DataMapper nested set plugin that works"
  s.description = s.summary
  s.author = "Jeremy Nicoll"
  s.email = "jnicoll@gnexp.com"
  s.homepage = "http://gnexp.com/"
  s.add_dependency('dm-core',       '>= 0.10.0')
  s.add_dependency('dm-adjust',     '>= 0.10.0')
  s.add_dependency('dm-aggregates', '>= 0.10.0')
  s.require_path = 'lib'
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the plugin as a gem"
task :install => [:package] do
  sh %{sudo gem install pkg/#{spec.name}-#{spec.version}}
end

desc "Uninstall the gem"
task :uninstall do
  sh %{sudo gem uninstall #{spec.name} --version #{spec.version}}
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
