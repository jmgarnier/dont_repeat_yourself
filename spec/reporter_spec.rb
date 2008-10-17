require File.dirname(__FILE__) + '/spec_helper'

describe "a Rails project" do
  before :each do
    @reporter = DontRepeatYourself::RailsProjectReporter.new
  end
      
  it "should have the name of its project root folder" do
    @reporter.project_basename.should == "rails_plugin" 
  end
    
  it "should generate the DRY report" do
    @reporter.report.should_not be_nil
  end    

  it "should configure simian to use the RAILS_ROOT for the base directory" do                        
    @reporter.configure_simian
    class DontRepeatYourself::ProjectReporterBase
      def basedir
        @simian_runner.basedir
      end
    end
    @reporter.basedir.should == File.expand_path(RAILS_ROOT)
  end  
      
end 


