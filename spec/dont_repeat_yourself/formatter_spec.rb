require File.dirname(__FILE__) + '/../spec_helper'

describe "Report formatters:\n" do

  before :each do                 
    # TODO Mock Simian Result
    yaml_results = YAML.load( read_simian_log("dummy_simian_log.yaml") )
    @simian_results = DontRepeatYourself::SimianResults.new(yaml_results)        
  end                    
  
  describe "Formatters:\n" do 
    before :each do
      # This is typically the class which is difficult to spec without a library to
      # record calls amd replay inputs / outputs
      @snippet_extractor = DontRepeatYourself::SnippetExtractor.new        
    
      @duplicate_lines = 
%Q!    puts "a bit of dupplicate lines"
    puts "a bit of dupplicate lines"
    puts "a bit of dupplicate lines"
    puts "a bit of dupplicate lines"
    puts "a bit of dupplicate lines"
    puts "a bit of dupplicate lines"!
          
      mock(@snippet_extractor).plain_source_code(anything, anything, anything){ @duplicate_lines }          
    end
                                                                        
    DontRepeatYourself::REPORT_TYPES.each{|report_type|      
      formatter_class = DontRepeatYourself.const_get("#{report_type}Formatter")
      describe formatter_class do
        before :each do
          @custom_formatter = formatter_class.new(@snippet_extractor, @simian_results)
          
        end
        
        it "should generate the #{report_type} report" do
          expected = IO.read(File.dirname(__FILE__) + "/expected/#{report_type}.html")
#                    puts @custom_formatter.report
#                    puts expecteda
          @custom_formatter.report.should == expected
        end    
      end
    }        

  end
  
  describe DontRepeatYourself::FormatterFactory do
    DontRepeatYourself::REPORT_TYPES.each{|report_type|      
      it "should create a #{report_type} formatter when report type = #{report_type}" do
        DontRepeatYourself::FormatterFactory.create_report(report_type, @simian_results).should_not be_nil
      end
    }
    
    it "should throw an error if the report type does not exist" do
      lambda { DontRepeatYourself::FormatterFactory.create_report("does not exist", @simian_results) }.should raise_error(NameError)      
    end 
    
  end
  
end
