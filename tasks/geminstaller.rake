require File.dirname(__FILE__) + '/../lib/d_r_y_gem_installer'

namespace :gems do
  # OPTIMIZE Replace this by Rails 2.1.0 gems:install ???
  desc 'Install correct versions of dependencies for dont_repeat_yourself plugin'
  task :install_dependencies_dry  do      
    DRYGemInstaller.install
  end  
         
end
