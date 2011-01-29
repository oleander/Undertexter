# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "undertexter/version"

Gem::Specification.new do |s|
  s.name        = "undertexter"
  s.version     = "0.0.6"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "https://github.com/oleander/Undertexter"
  s.summary     = %q{A subtitle search client for undertexter.se}
  s.description = %q{A subtitle search client to search for swedish subtitles on undertexter.se}

  s.rubyforge_project = "undertexter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('rest-client')
  s.add_dependency('nokogiri')
  s.add_development_dependency('rspec')
end
