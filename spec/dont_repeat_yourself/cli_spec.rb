require File.dirname(__FILE__) + '/../spec_helper'

module DontRepeatYourself
  describe CLI do
    before :each do
      @cli = CLI.new
    end
    
    describe "Default arguments:" do
      before :each do
        @cli.parse_options!([])
      end
      
      it "should use the current directory as base directory" do
        @cli.options[:basedir].should == './'
      end
      
      it "should output in 'default' format" do
        @cli.options[:format].should == 'default'
      end            
      
    end
    
    describe "Parameters:" do
      it "should have the option --basedir to specify the base directory of the Ruby project to process" do            
        @cli.parse_options!(%w{--basedir ./blabla})
        @cli.options.should == {
          :format => "default",
          :basedir => './blabla'
        }
      end
      
      it "should have the option --threshold " do            
        @cli.parse_options!(%w{--threshold 4})
        @cli.options.should == {
          :format => "default",
          :basedir => './',
          :threshold => 4
        }
      end      
      
      it "should complain if FORMAT is invalid and exit" do
        lambda { @cli.parse_options!(%w{--format invalid}) }.should raise_error(SystemExit)              
      end
      
      it "should have an --help and exit" do
        lambda { @cli.parse_options!(%w{--help}) }.should raise_error(SystemExit)              
      end
      
    end # "Parameters:"
  
    describe "When executed:" do
      before :each do                
        @basedir = "./"               
        @ruby_project_reporter = DontRepeatYourself::RubyProjectReporter.new(@basedir)        
      end
      
      it "should assign the basedir parameter" do        
        mock(DontRepeatYourself::RubyProjectReporter).new(@basedir){ @ruby_project_reporter }                        
        cli = CLI.parse([])
        cli.execute!
      end
      
      it "should assign the threshold parameter" do
        stub(DontRepeatYourself::RubyProjectReporter).new(anything){ @ruby_project_reporter }                        
        mock(@ruby_project_reporter).with_threshold_of_duplicate_lines(4){ @ruby_project_reporter }
        cli = CLI.parse(%w{--threshold 4})
        cli.execute!
      end
      
      it "should assign the format parameter" do
        stub(DontRepeatYourself::RubyProjectReporter).new(anything){ @ruby_project_reporter }                        
        mock(@ruby_project_reporter).with_netbeans_reporting{ @ruby_project_reporter }
        cli = CLI.parse(%w{--format netbeans})
        cli.execute!
      end
      
      it "should run simian and output the report to STDOUT" do
        stub(DontRepeatYourself::RubyProjectReporter).new(anything){ @ruby_project_reporter }                        
        mock(@ruby_project_reporter).report{ "some report" }
        mock(STDOUT).print("some report")
        
        cli = CLI.parse([])
        cli.execute!
      end
      
    end
    
  end # describe CLI
end # module DontRepeatYourself