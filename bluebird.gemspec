Gem::Specification.new do |s|
  s.name = "bluebird"
  s.version = "0.0.2"
  s.date = "2009-01-11"
  s.summary = "An XSL-like DSL for transforming XML, written in Ruby"
  s.email = "goodieboy@gmail.com"
  s.homepage = "http://github.com/mwmitchell/bluebird"
  s.description = "An XSL-like DSL for transforming XML, written in Ruby"
  s.has_rdoc = true
  s.authors = ["Matt Mitchell"]
  s.files = [
    "example.rb",
    "lib/core_ext.rb",
    "lib/bluebird.rb",
  ]
  s.test_files = [
    
  ]
  #s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = %w(LICENSE README.rdoc example.rb)
  s.add_dependency('nokogiri', '1.1.0')
end