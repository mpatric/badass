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

  s.add_runtime_dependency(%q<rails>, ["~> 3.2.0"])
  s.add_runtime_dependency(%q<mysql2>, ["~> 0.5.3"])
  s.add_runtime_dependency(%q<rake>, ["~> 10.5.0"])
  s.add_runtime_dependency(%q<authlogic>, ["~> 3.2.0"])
  s.add_runtime_dependency(%q<bluecloth>, ["~> 2.2.0"])
  s.add_runtime_dependency(%q<will_paginate>, ["~> 3.1.0"])
  s.add_runtime_dependency(%q<gravatar>, ["~> 1.0"])
  s.add_runtime_dependency(%q<rakismet>, ["~> 1.5.1"])
  s.add_runtime_dependency(%q<sass>, ["~> 3.4.21"])
  s.add_runtime_dependency(%q<haml>, ["~> 4.0.2"])
  s.add_runtime_dependency(%q<paperclip>, ["~> 4.2.2"])
  s.add_runtime_dependency(%q<grackle>, ["~> 0.3.0"])
  s.add_runtime_dependency(%q<aws-sdk>, ["~> 1.5.7"])
  s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6.7"])
  s.add_runtime_dependency(%q<recaptcha>, ["~> 4.3.1"])
end
