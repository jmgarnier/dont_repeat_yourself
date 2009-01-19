require File.dirname(__FILE__) + '/../spec_helper'

describe "RSpec Custom Matchers" do
  
  before :each do
    @this_project = this_project
  end

  # We have some duplicate lines in app/model: WILL FAIL
  #  it { rails_application.with_netbeans_reporting.should be_DRY }
  
  #  it "should have a custom expectation matcher be_DRY for the current rails_application" do
  #    rails_application.should_not be_DRY # our application is not DRY on purpose ;-)
  #  end
  
  #  it "should have a custom expectation matcher be_DRY" do
  #    ruby_code_in_rails_plugin("dont_repeat_yourself").
  #      should be_DRY
  #  end
  #
  #  it { ruby_code_in_rails_plugin("dont_repeat_yourself").
  #         should be_DRY }
  
  it "should use a fluent interface with a RSpec matcher which returns itself so we can specify: with_threshold_of_duplicate_lines" do    
    @this_project.
      with_threshold_of_duplicate_lines(256).
      should follow_the_dry_principle
  end
  
  it "should use a fluent interface so we can specify: with_netbeans_reporting" do    
    @this_project.
      with_threshold_of_duplicate_lines(256).
      with_netbeans_reporting.
      should follow_the_dry_principle
  end  
  
  # to cover the 
  it { @this_project.with_threshold_of_duplicate_lines(256).should follow_the_dry_principle }

  describe "rails_application helper" do
    
    # We have some duplicate lines on purpose in the app/models
    it "should provide an helper for Rails apps" do
      rails_application(fake_rails_app_basedir).
        with_netbeans_reporting.
        should_not follow_the_dry_principle
    end
  end 

end