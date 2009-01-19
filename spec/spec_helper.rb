require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/../lib/dont_repeat_yourself'
require File.dirname(__FILE__) + '/../lib/dont_repeat_yourself/unit_testing_helpers'

Spec::Runner.configure do |config|
  config.mock_with :rr # mock framework, see http://github.com/btakita/rr/  
  config.include DontRepeatYourself::UnitTestingHelpers::RSpecMatchers
end

def this_project
  ruby_project(File.dirname(__FILE__) + '/..')
end

def fake_rails_app_basedir
  File.expand_path(File.dirname(__FILE__) + "/rails_webapp")
end

def read_simian_log(filename)
  IO.read(File.dirname(__FILE__) + "/simian_logs/#{filename}")
end

# TODO Too much magic making this unreadable ???
def have_a(attribute_symbol)
  #  with_the_default_value_of
  return simple_matcher("have attribute '#{attribute_symbol.to_s}' ")  do |instance| 
    (instance.send(attribute_symbol)) != nil
  end        
end

def have_a_default_value(attribute_symbol, default_value)
  return simple_matcher("have attribute '#{attribute_symbol.to_s}' with default value '#{default_value}'")  do |instance| 
    (instance.send(attribute_symbol)) == default_value
  end
end

def use_a_fluent_interface_for_setting_the(attribute_symbol, example_value)
  return simple_matcher("use a fluent interface for setting the attribute '#{attribute_symbol.to_s}' with #{example_value} (for example)")  do |instance| 
    (instance.send("with_#{attribute_symbol}", example_value)) == instance
  end
end

def change_scope_of_method_to_public(clazz, method)
  eval("class #{clazz}
          public(:#{method.to_s})
        end")
end
