require File.dirname(__FILE__) + '/spec_helper'

describe "Rails unit testing helpers:" do

  describe "\nEating its own dog food ;-) This plugin" do
    it { ruby_code_in_rails_plugin("dont_repeat_yourself").
        with_threshold_of_duplicate_lines(2).
        with_netbeans_reporting.
        should be_dry }
  end
  
  describe "rails_application helper" do
    # We habe some duplicate lines on purpose in the app/models
    it { rails_application.
        with_netbeans_reporting.
        should_not be_dry }
  end 
      
end
  
 


