require File.dirname(__FILE__) + '/reporter'
require 'spec'

# TODO separate the file!
require 'test/unit/assertions'

module DontRepeatYourself
  
  module UnitTestingHelpers
        
    module RubyProjectHelpers           
      def ruby_project(project_path)
        DontRepeatYourself::RubyProjectReporter.new(project_path)
      end
      def ruby_code_in_rails_plugin(plugin_name)
        DontRepeatYourself::RailsPluginProjectReporter.new(plugin_name)
      end

      def rails_application(rails_root = RAILS_ROOT)
        DontRepeatYourself::RailsProjectReporter.new(rails_root)
      end
    end

    module TestUnitExtension
      include DontRepeatYourself::UnitTestingHelpers::RubyProjectHelpers
                  
      def assert_dry(project)
        assert(project.is_dry?, project.failure_message)
      end    
    end   

    module RSpecMatchers
      
      include DontRepeatYourself::UnitTestingHelpers::RubyProjectHelpers
      
      class BeDRYMatcher
                              
        def matches?(project)
          @project = project
          @project.is_dry?
        end
              
        # TODO Do we really need this? It does not make a lot of sense
        def negative_failure_message
          "expected #{@project.name} to have more than #{@project.maximum_number_of_duplicate_lines_i_want_in_my_project} duplicate lines :\n but found the following:\n "
        end
      
        def description
          "follow the 'Don't Repeat Yourself' principle " << @project.description
        end
        
        def failure_message
          @project.failure_message
        end
    
      end        
    
      # Custom expectation matcher
      def follow_the_dry_principle
        DontRepeatYourself::UnitTestingHelpers::RSpecMatchers::BeDRYMatcher.new
      end                          
    
    end
  end
end

# Automatically includes assert_dry
module Test
  module Unit
    class TestCase #:nodoc:
      include DontRepeatYourself::UnitTestingHelpers::RubyProjectHelpers
      include DontRepeatYourself::UnitTestingHelpers::TestUnitExtension
    end
  end
end

