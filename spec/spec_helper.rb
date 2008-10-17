require 'rubygems'

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'spec'
require 'spec/rails'


# We will load the current version of the gem code, not the current classes from the project
require 'dont_repeat_yourself'

require File.dirname(__FILE__) + '/../lib/rails_reporter'

Spec::Runner.configure do |config|
  config.mock_with :rr
end