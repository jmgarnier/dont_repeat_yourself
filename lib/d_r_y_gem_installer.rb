# To change this template, choose Tools | Templates
# and open the template in the editor.

class DRYGemInstaller
  def self.install
    
    begin
      require 'rubygems'
      require "geminstaller"

      #   Path(s) to your GemInstaller config file(s)
      config_paths = "#{ File.dirname(__FILE__ )}/../config/geminstaller.yml"

      #   Arguments which will be passed to GemInstaller (you can add any extra ones)
      args = "--config #{config_paths}"

      #   The 'exceptions' flag determines whether errors encountered while running GemInstaller
      #   should raise exceptions (and abort Rails), or just return a nonzero return code
      args += " --exceptions"

      #   This will use sudo by default on all non-windows platforms, but requires an entry in your
      #   sudoers file to avoid having to type a password.  It can be omitted if you don't want to use sudo.
      #   See http://geminstaller.rubyforge.org/documentation/documentation.html#dealing_with_sudo
      args += " --sudo" unless RUBY_PLATFORM =~ /mswin/

      #   The 'install' method will auto-install gems as specified by the args and config
      GemInstaller.run(args)

      #   The 'autogem' method will automatically add all gems in the GemInstaller config to your load path, using the 'gem'
      #   or 'require_gem' command.  Note that only the *first* version of any given gem will be loaded.
      GemInstaller.autogem(args)
      
      puts "geminstaller status: All dependencies are installed with correct versions"
    rescue LoadError => e
      puts e.message
      puts <<EOF
      **********************************************************************************"
      WARNING: You see this message because you haven't installed geminstaller.

      PLEASE install it with 'sudo gem install geminstaller' and run
      sudo rake gems:install_dependencies_dry

      OR install manually the dependencies of this plugin:
      1. run the following if you haven't already:
        gem sources -a http://gems.github.com

      2. dry-report:
        sudo gem install garnierjm-dry-report --version 0.1

      3. syntax:
        gem install syntax
      
      For more information about geminstaller, see http://geminstaller.rubyforge.org
      **********************************************************************************"
EOF
      
    end      
   
  end
  
end
