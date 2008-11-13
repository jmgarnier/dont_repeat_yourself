require File.dirname(__FILE__) + '/rails_reporter'

module DontRepeatYourself
  
  module UnitTestingHelpers
    
    module RailsHelpers
      def ruby_code_in_rails_plugin(plugin_name)
        DontRepeatYourself::RailsPluginProjectReporter.new(plugin_name)
      end
          
      def rails_application
        DontRepeatYourself::RailsProjectReporter.new
      end                  
    end
  end
end

# Automatically includes assert_dry
module Test
  module Unit
    class TestCase #:nodoc:
      include DontRepeatYourself::UnitTestingHelpers::RailsHelpers
    end
  end
end
