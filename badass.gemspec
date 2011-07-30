$:.push File.expand_path("../lib", __FILE__)
require "badass/version"

Gem::Specification.new do |s|
  s.name = "badass"
  s.version = Badass::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Michael Patricios"]
  s.email = ["michael@mpatric.com"]
  s.homepage = %q{http://github.com/mpatric/badass}
  s.summary = %q{Badass blogging rails engine}
  s.description = %q{Badass blogging rails engine}

  s.rubyforge_project = ""

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<rails>, ["3.0.9"])
  s.add_runtime_dependency(%q<mysql2>, ["0.2.11"])
  s.add_runtime_dependency(%q<rake>, ["0.8.7"])
  s.add_runtime_dependency(%q<authlogic>, ["3.0.3"])
  s.add_runtime_dependency(%q<bluecloth>, ["2.0.11"])
  s.add_runtime_dependency(%q<will_paginate>, ["2.3.15"])
  s.add_runtime_dependency(%q<gravatar>, ["1.0"])
  s.add_runtime_dependency(%q<rakismet>, ["0.4.2"])
  s.add_runtime_dependency(%q<sass>, ["3.1.2"])
  s.add_runtime_dependency(%q<paperclip>, ["2.3.11"])
  s.add_runtime_dependency(%q<grackle>, ["0.1.10"])
  s.add_runtime_dependency(%q<aws-s3>, ["0.6.2"])
  s.add_runtime_dependency(%q<nokogiri>, ["1.5.0"])
end