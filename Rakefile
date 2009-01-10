require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
require File.join(File.dirname(__FILE__), 'lib', 'bluebird')

task :default => [:test_units]
 
desc "Run basic tests"
Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = true
}
  
# Rdoc
desc 'Generate documentation for the rsolr gem.'
Rake::RDocTask.new(:doc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'Solr-Ruby'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end