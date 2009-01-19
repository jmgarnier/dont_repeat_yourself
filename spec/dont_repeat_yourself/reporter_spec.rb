require File.dirname(__FILE__) + '/../spec_helper'

describe "DRY Project reporter," do

  describe "a base project" do
    before(:each) do
      @base_project = DontRepeatYourself::ProjectReporterBase.new("a name")
    end
    
    it { @base_project.should have_a(:name) }
    it { @base_project.should have_a(:report_type) }
    it { @base_project.should have_a_default_value(:report_type, DontRepeatYourself::DEFAULT_REPORT) }
    
    DontRepeatYourself::REPORT_TYPES.each{|report_type|      
      it "should allow to change the report type to '#{report_type}' with a fluent interface" do
        @base_project.send("with_#{report_type.downcase}_reporting").should == @base_project
        @base_project.report_type.should == report_type
      end
    }
    
    it { @base_project.should have_a( :maximum_number_of_duplicate_lines_i_want_in_my_project) }
    it { @base_project.should have_a_default_value(:maximum_number_of_duplicate_lines_i_want_in_my_project, 0) }
    # TODO
    #    it { @base_project.should have_a(:report_type).with_the_default_value_of(DontRepeatYourself::DEFAULT_REPORT) }

    # FIXME : Test anti pattern: code is not understandable !
    it { @base_project.should use_a_fluent_interface_for_setting_the(:threshold_of_duplicate_lines, 3) }
        
    it "should generate a description" do
      @base_project.description.should == "DRY\n" << "  - with a threshold of 3 duplicate lines"
    end
    
    it "should have an utility to extract the basename of a directory" do
      class DontRepeatYourself::ProjectReporterBase
        public(:basename_of_directory)
      end
      @base_project.basename_of_directory(File.dirname(__FILE__)).should == "dont_repeat_yourself"
    end
    
  end
    
  describe "a Ruby project" do
    before :each do      
      @reporter = this_project
      @reporter.configure_simian
    end
       
    it "should add the '<BASEDIR>/lib' folder automatically" do
      @reporter.patterns_of_directories_to_search_for_duplicate_lines.should_not be_empty
      @reporter.patterns_of_directories_to_search_for_duplicate_lines.first.should include("lib")
    end
    
    it "should add the '<BASEDIR>/test/**/*.rb' folder automatically if it exist" do
      @reporter.patterns_of_directories_to_search_for_duplicate_lines.to_s.should_not include("test")
    end
    
    it "should add the '<BASEDIR>/spec/**/*.rb' folder automatically if it exist" do
      @reporter.patterns_of_directories_to_search_for_duplicate_lines.to_s.should include("spec")
    end
  end

  describe "a Rails project" do
    before :each do
      @reporter = DontRepeatYourself::RailsProjectReporter.new(fake_rails_app_basedir)
    end

    it "should have the name of its project root folder" do
      @reporter.name.should == "rails_webapp"
    end

    it "should generate the DRY report" do
      @reporter.report.should_not be_nil
    end

    it "should configure simian and behave like a ruby project"

  end
  
  describe "\nEating its own dog food ;-) This plugin" do
    it { this_project.
          with_threshold_of_duplicate_lines(3).
          with_netbeans_reporting.
          ignoring_the_file("spec/dont_repeat_yourself/formatter_spec.rb"). # contain duplicate lines on purpose
          ignoring_the_directory("spec/rails_webapp"). # same
            should follow_the_dry_principle }
  end

end
