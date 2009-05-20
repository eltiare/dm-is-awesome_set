# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-awesome_set}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Nicoll"]
  s.date = %q{2009-05-20}
  s.description = %q{DataMapper nested set plugin that works}
  s.email = %q{jnicoll@gnexp.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/dm-is-awesome_set", "lib/dm-is-awesome_set/is", "lib/dm-is-awesome_set/is/awesome_set.rb", "lib/dm-is-awesome_set.rb", "spec/dm-is-awesome_set_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://gnexp.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dm-is-awesome_set}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{DataMapper nested set plugin that works}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_runtime_dependency(%q<dm-adjust>, [">= 0.10.0"])
      s.add_runtime_dependency(%q<dm-aggregates>, [">= 0.10.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_dependency(%q<dm-adjust>, [">= 0.10.0"])
      s.add_dependency(%q<dm-aggregates>, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.10.0"])
    s.add_dependency(%q<dm-adjust>, [">= 0.10.0"])
    s.add_dependency(%q<dm-aggregates>, [">= 0.10.0"])
  end
end
