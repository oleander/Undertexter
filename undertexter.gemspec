# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "undertexter"
  s.version     = "0.1.10"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "https://github.com/oleander/Undertexter"
  s.summary     = %q{A basic API for Undertexter.se}
  s.description = %q{A basic API for Undertexter.se.}

  s.rubyforge_project = "undertexter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("rest-client", "1.6.1")  
  s.add_dependency("nokogiri", "1.4.4")
  s.add_dependency("mimer_plus", "0.0.4")
  s.add_dependency("levenshteinish", "0.0.3")
  
  s.add_development_dependency("rspec", "2.4.0")
  s.add_development_dependency("webmock", "1.6.2")
  s.add_development_dependency("vcr", "1.9.0")
end
