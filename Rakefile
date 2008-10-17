require 'rubygems'
require 'rake'

require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']  
end

desc "Generate documentation for the dont_repeat_yourself plugin and store html output in doc.html"
Spec::Rake::SpecTask.new('doc') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
#  t.spec_opts = ['--format html:./doc.html']
  t.spec_opts = ['--format specdoc:./doc.txt']
end

desc "Run all examples with RCov and generate specs coverage report"
Spec::Rake::SpecTask.new('coverage') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,boot.rb']
end