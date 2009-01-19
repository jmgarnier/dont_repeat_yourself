require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

#-------- Deployment tasks
begin
  require "hoe"
rescue LoadError
  puts "This Rakefile requires the 'hoe' RubyGem."
  puts "Installation: (sudo) gem install hoe -y"
  exit
end

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'dont_repeat_yourself/version'

# FIXME In ordert to remove hoe from gemspec, DOES NOT WORK!
class Hoe
  def extra_deps
    @extra_deps.reject! { |x| Array(x).first == 'hoe' }
    @extra_deps
  end
end

AUTHOR = 'Jean-Michel Garnier'  # can also be an array of Authors
EMAIL = 'jm AT 21croissants dot com'
DESCRIPTION = 'Generate duplicate lines report'
GEM_NAME = 'dont_repeat_yourself' # what ppl will type to install your gem
HOMEPATH = "http://github.com/garnierjm/dont_repeat_yourself"
VERS = DontRepeatYourself::VERSION::STRING

hoe = Hoe.new(GEM_NAME, VERS) do |p|
  p.developer(AUTHOR, EMAIL)
  p.description = DESCRIPTION
  p.summary = DESCRIPTION
  p.url = HOMEPATH  
  p.clean_globs |= ['.project', '.gitignore', '**/.*.sw?', '*.gem', '.config', '**/.DS_Store', '**/*.class']  #An array of file patterns to delete on clean.

  # == Optional

  # An array of rubygem dependencies [name, version], e.g. [ ['active_support', '>= 1.3.1'] ]
  p.extra_deps = [ ['syntax', ">= 1.0.0"] ]
  
end

desc "Refresh #{GEM_NAME}.gemspec to include ALL files"
task :refresh_gemspec => 'refresh_manifest' do
  File.open("#{GEM_NAME}.gemspec", 'w') {|io| io.write(hoe.spec.to_ruby)}
end

desc 'Recreate Manifest.txt to include ALL files'
task :refresh_manifest do
  manifest_files = %w(SIMIAN-LICENSE MIT-LICENSE README.txt Rakefile) + Dir.glob("{bin,lib}/**/*")
  File.open("Manifest.txt", 'w') {|io| io.write(manifest_files.join("\n"))}
end


desc 'Install the package as a gem, without generating documentation(ri/rdoc)'
task :install_gem_no_doc => [:clean, :package] do
  sh "#{'sudo ' unless Hoe::WINDOZE }gem install pkg/*.gem --no-rdoc --no-ri"
end

namespace :manifest do
  desc 'Recreate Manifest.txt to include ALL files'
  task :refresh do
    `rake check_manifest | patch -p0 > Manifest.txt`
  end
end

#-------------- Testing taks
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
  t.spec_opts = ['--format html:./doc.html']
  #  t.spec_opts = ['--format specdoc:./doc.txt']
end

desc "Run all examples with RCov and generate specs coverage report"
Spec::Rake::SpecTask.new('coverage') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,boot.rb']
end

require 'cucumber/rake/task'
desc "Run User Acceptance tests with cucumber"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

def egrep(pattern)
  Dir['**/*.rb'].each do |fn|
    count = 0
    open(fn) do |f|
      while line = f.gets
        count += 1
        if line =~ pattern
          puts "#{fn}:#{count}:#{line}"
        end
      end
    end
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep /(FIXME|TODO|TBD)/
end
