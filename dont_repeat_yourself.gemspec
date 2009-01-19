# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dont_repeat_yourself}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jean-Michel Garnier"]
  s.date = %q{2009-01-19}
  s.default_executable = %q{dry-report}
  s.description = %q{Generate duplicate lines report}
  s.email = ["jm AT 21croissants dot com"]
  s.executables = ["dry-report"]
  s.extra_rdoc_files = ["README.txt"]
  s.files = ["SIMIAN-LICENSE", "MIT-LICENSE", "README.txt", "Rakefile", "bin/dry-report", "lib/assets", "lib/assets/dry.css", "lib/assets/dry.js", "lib/dont_repeat_yourself", "lib/dont_repeat_yourself/formatter.rb", "lib/dont_repeat_yourself/reporter.rb", "lib/dont_repeat_yourself/simian_results.rb", "lib/dont_repeat_yourself/simian_runner.rb", "lib/dont_repeat_yourself/snippet_extractor.rb", "lib/dont_repeat_yourself/unit_testing_helpers.rb", "lib/dont_repeat_yourself/cli.rb", "lib/dont_repeat_yourself/version.rb", "lib/jars", "lib/jars/simian-2.2.24.jar.xyz", "lib/dont_repeat_yourself.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/garnierjm/dont_repeat_yourself}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dont_repeat_yourself}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Generate duplicate lines report}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<syntax>, [">= 1.0.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<syntax>, [">= 1.0.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<syntax>, [">= 1.0.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
