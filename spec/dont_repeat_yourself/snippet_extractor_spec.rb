require File.dirname(__FILE__) + '/../spec_helper'

describe DontRepeatYourself::SnippetExtractor do
  
  before :each do 
    @snippet_extractor = DontRepeatYourself::SnippetExtractor.new
  end
  
  it "should extract the plaint text source code from the file when specifying a file, a starts line number and an ends line number" do
    expected_source = "  before :each do 
    @snippet_extractor = DontRepeatYourself::SnippetExtractor.new
  end"
    
    @snippet_extractor.plain_source_code(5, 7, File.dirname(__FILE__) + "/snippet_extractor_spec.rb").should == expected_source
  end  
  
  it "should return # Couldn't get snippet when the file path or line numbers are invalid" do
    @snippet_extractor.plain_source_code(6, 8, "/does not exist").should == "# Couldn't get snippet for /does not exist"
  end
  
  it "should use the syntax gem to output the code with syntax highlighting" do
    @snippet_extractor.snippet(1, 36, File.dirname(__FILE__) + "/snippet_extractor_spec.rb").
      should include("html")
  end
  
end