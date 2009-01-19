$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'dont_repeat_yourself'

#Given I am working on a Ruby projet dry-report whose base directory is '.'
Given /I am working on a Ruby project (.*) whose base directory is (.*)/ do |project, base_directory|  
  @reporter = DontRepeatYourself::RubyProjectReporter.new(base_directory)    
end

# Given my IDE is Textmate
Given /my IDE is (.*)/ do |ide|  
  @reporter.send("with_#{ide.downcase}_reporting")
end

When /I generate a DRY HTML report and click on the link of a duplicate line/ do
  @report = @reporter.report  
end

Then "it should open automatically Textmate with the class which contain the duplication and go to the line number where duplication starts" do
  @report.should include("'txmt://open?url=file:")
end
