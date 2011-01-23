# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "undertexterse/version"

Gem::Specification.new do |s|
  s.name        = "undertexterse"
  s.version     = Undertexterse::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "https://github.com/oleander/Undertexterse"
  s.summary     = %q{An subtitle search client for undertexter.se}
  s.description = %q{An subtitle search client to search for swedish subtitles on undertexter.se}

  s.rubyforge_project = "undertexterse"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('rest-client')
  s.add_dependency('nokogiri')
  s.add_development_dependency('rspec')
end
