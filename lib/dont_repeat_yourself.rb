$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'dont_repeat_yourself/cli'
require 'dont_repeat_yourself/unit_testing_helpers'

module DontRepeatYourself  
end