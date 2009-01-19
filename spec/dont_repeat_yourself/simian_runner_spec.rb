require File.dirname(__FILE__) + '/../spec_helper'

describe DontRepeatYourself::SimianRunner do
  
  before :each do 
    @simian_runner = DontRepeatYourself::SimianRunner.new
  end    
  
  def this_gem_base_directory
    File.dirname(__FILE__) + "/../.."
  end
  
  it "should allow to change the base directory to an existing directory" do    
    @simian_runner.basedir= File.dirname(__FILE__)
  end
  
  it "should have a default 'threshold' of 3" do    
    @simian_runner.threshold.should == 3      
  end
  
  it "should have accessor to the 'threshold' attribute" do    
    @simian_runner.threshold= 5      
  end
  
  it "should throw an error if 'threshold' < 2" do   
    lambda { @simian_runner.threshold=1 }.should raise_error(ArgumentError)      
  end
    
  describe "When configuring source directories" do
    before :each do
      @simian_runner.basedir = File.dirname(__FILE__) + "/../rails_webapp"
    end   
    
    it "should save the simian log file in the base directory of the runner" do
      @simian_runner.simian_log_file.should include(DontRepeatYourself::SimianRunner::SIMIAN_LOGFILE_NAME)
    end
    
    it "should trown an Argument error if the specified directory does not exist" do    
      lambda { @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("nothing_here")  }.should raise_error(ArgumentError)      
    end
    
    it "should get the simian pattern (eg: 'lib/**/*.rb') for each ruby directory (eg: 'lib') to search for duplicate lines " do    
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("lib") 
      @simian_runner.patterns_of_directories_to_search_for_duplicate_lines[0].should == 'lib/*.rb'
      @simian_runner.patterns_of_directories_to_search_for_duplicate_lines[1].should == 'lib/**/*.rb'
    end
  
    it "should trown an Argument error if no directory has been added" do    
      lambda { @simian_runner.run }.should raise_error(ArgumentError)
    end
            
    it "should generate the parameter '-includes' for the command line " do    
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("app") 
      @simian_runner.add_html_directory_to_search_for_duplicate_lines("app/views") 

      class DontRepeatYourself::SimianRunner
        public(:parameter_includes)
      end    
      @simian_runner.parameter_includes.should include("-includes=")
      @simian_runner.parameter_includes.should include("/app/**/*.rb")
      @simian_runner.parameter_includes.should include("/views/**/*.*html")
      #   -includes=/home/jeanmichel/ruby/projects/21croissants_plugins/app/**/*.rb
    end
    
    describe "\When excluding a path (file or directory):" do
      before :each do
        @simian_runner.basedir = this_gem_base_directory
        change_scope_of_method_to_public(DontRepeatYourself::SimianRunner, :parameter_excludes)
      end            
            
      it "should add the name of the ignored file to the list of *excludes*" do
        @simian_runner.ignore_file("spec/dont_repeat_yourself/formatter_spec.rb")
        @simian_runner.parameter_excludes.should include("spec/dont_repeat_yourself/formatter_spec.rb")
      end
      
      it "should thow an exception if the file does not exist" do
        lambda { @simian_runner.ignore_file("dfsfd/dsff.rb") }.should raise_error(ArgumentError)
      end

      it "should add the name of the ignored directory after the -excludes parameter" do
        @simian_runner.ignore_directory("spec/rails_webapp")
        @simian_runner.parameter_excludes.should include("rails_webapp/**/*.rb")
      end

      it "should thow an exception if the directory does not exist" do
        lambda { @simian_runner.ignore_directory("dfsfd") }.should raise_error(ArgumentError)
      end
      
    end
    
    describe "When building the command line to call simian:" do
      before :each do
        @simian_runner.basedir = this_gem_base_directory
        change_scope_of_method_to_public(DontRepeatYourself::SimianRunner, :command_line)        
      end
      
      it "should add the -excludes parameter followed by a list of excluded files" do
        @simian_runner.ignore_file("spec/dont_repeat_yourself/formatter_spec.rb")
        @simian_runner.command_line.should include("-excludes=")
      end
      
    end
    
    describe "\When running simian:" do
      before :each do
        @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("app") 
        class DontRepeatYourself::SimianRunner
          public(:run_java, :simian_output_with_header_removed)
        end
      end
      
      it "should throw an exception if java executable is not installed"
      
      it "should run successfully the java program Simian and write the result to a simian_log.yaml file " do            
        @simian_runner.run_java
        File.file?(@simian_runner.simian_log_file).should be_true    
      end
    
      it "should remove the Simian license header so the yaml file is syntaxically correct" do
        @simian_runner.run_java
      
        # TODO Remove the IO.read, encapsulate it! I never know if it's a string or a file (despite the suffix file!!!)
        log_file = @simian_runner.simian_output_with_header_removed
        log_file.should_not include("Similarity Analyser 2.2.24 - http://www.redhillconsulting.com.au/products/simian/index.html")
        log_file.should_not include("Copyright (c) 2003-08 RedHill Consulting Pty. Ltd.  All rights reserved.")
        log_file.should_not include("Simian is not free unless used solely for non-commercial or evaluation purposes.")
        log_file.should_not include("---")        
    
        log_file.should include("summary")
      end
    
      it "should return the content of the simian yaml log file parsed into an Hash" do        
        @simian_runner.run.should be_an_instance_of(Hash)
      end
    
      it "should delete the log file after the generation of the report" do
        @simian_runner.run
        File.file?(@simian_runner.simian_log_file).should be_false
      end  
    end
  end
  
  it "should output the result in yaml format" do    
    @simian_runner.formatter_option.should == "-formatter=yaml"
  end
  
  it "should get the Simian jar path" do    
    @simian_runner.simian_jar_path.should include("simian") 
  end
  
  it "should get the command line with the java executable" do    
    @simian_runner.executable.should include("java -jar ") 
    @simian_runner.executable.should include("simian-2.2.24.jar.xyz")
  end
  
  it "should throw an Argument Missing exception if the basedir is not specified" do        
    lambda { @simian_runner.basedir = "some funky folder which does not exist"  }.should raise_error(ArgumentError)      
  end        
  
  it "should generate the parameter '-threshold' for the command line " do    
    class DontRepeatYourself::SimianRunner
      public(:parameter_threshold)
    end 
    @simian_runner.parameter_threshold.should == "-threshold=3"
  end          
  
  it "should report the error from Simian if there is a problem "      
  
end