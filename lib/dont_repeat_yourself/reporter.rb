require File.dirname(__FILE__) + '/simian_runner'
require File.dirname(__FILE__) + '/simian_results'
require File.dirname(__FILE__) + '/formatter'
require 'pathname'

module DontRepeatYourself
  
  # TODO Refactor: Use an enum gem / plugin here?
  DEFAULT_REPORT, HTML_REPORT, NETBEANS_REPORT, TEXTMATE_REPORT = 
    "Default", "HTML", "Netbeans", "TextMate" unless defined?(DontRepeatYourself::DEFAULT_REPORT)

  DEFAULT_REPORT_DESC   = "display the default plain report"
  NETBEANS_REPORT_DESC  = "display the report in the Output window of the Netbeans IDE (Ctrl+4)"
  HTML_REPORT_DESC      = "generate an DRY_report.html file in the project root folder"
  TEXTMATE_REPORT_DESC  = "to generate an html report with links which open files in the Textmate editor"
  
  REPORT_TYPES = [DEFAULT_REPORT, NETBEANS_REPORT, HTML_REPORT, TEXTMATE_REPORT] unless defined?(DontRepeatYourself::REPORT_TYPES)

  RUBY, RAILS, PLUGIN = "Ruby", "Rails", "Plugin" unless defined?(DontRepeatYourself::RUBY)
  REPORTER_TYPES = [RUBY, RAILS, PLUGIN] unless defined?(DontRepeatYourself::REPORTER_TYPES)

  class ProjectReporterBase
    attr_reader :name, :maximum_number_of_duplicate_lines_i_want_in_my_project, :report_type
      
    def initialize(name)
      @name = name
      @simian_runner = DontRepeatYourself::SimianRunner.new      
      
      # Default values
      @maximum_number_of_duplicate_lines_i_want_in_my_project = 0
      @report_type = DontRepeatYourself::DEFAULT_REPORT
    end      
    
    def patterns_of_directories_to_search_for_duplicate_lines
      @simian_runner.patterns_of_directories_to_search_for_duplicate_lines
    end
      
    # Fluent interface methods
    def with_threshold_of_duplicate_lines(threshold)
      @simian_runner.threshold = threshold        
      return self
    end
    
    # with_<REPORT_TYPE>_reporting fluent methods
    REPORT_TYPES.each do |report_type|
      define_method("with_#{report_type.downcase}_reporting") do        
        @report_type = eval("DontRepeatYourself::#{report_type.upcase}_REPORT")
        self
      end
    end           
    
    def ignoring_the_file(path)
      @simian_runner.ignore_file(path)
      self
    end

    def ignoring_the_directory(path)
      @simian_runner.ignore_directory(path)
      self
    end
    
    def basedir
      @simian_runner.basedir
    end
    
    def report
      DontRepeatYourself::FormatterFactory.create_report(@report_type, run_simian)
    end        
    
    # TODO Not very readable: you have to read the code of run_simian to understand
    def is_dry?
      run_simian.duplicate_line_count <= @maximum_number_of_duplicate_lines_i_want_in_my_project        
    end
    
    def description
      "DRY\n" << "  - with a threshold of #{@simian_runner.threshold} duplicate lines"
    end
    
    def failure_message      
      "expected #{@name} to have less or equal #{@maximum_number_of_duplicate_lines_i_want_in_my_project} duplicate lines :\n
         DRY Report:\n#{report}\n"
    end                 
    
    def self.build_reporter(reporter, basedir)
      case reporter
        when 'ruby' then DontRepeatYourself::RubyProjectReporter.new(basedir)
        when 'rails' then DontRepeatYourself::RailsProjectReporter.new(basedir)
        when 'plugin' then DontRepeatYourself::RailsPluginProjectReporter.new(basedir)
      end
    end
    protected       
    
    def run_simian
      return @simian_results if @simian_results # so we don't run simian if we already have results
      self.configure_simian      
      results_in_yaml_format = @simian_runner.run      
      @simian_results = DontRepeatYourself::SimianResults.new(results_in_yaml_format) 
    end        
    
    def basename_of_directory(directory)
      Pathname.new(directory).basename.to_s
    end
    
    def folder_exists?(folder)
      File.directory?(@simian_runner.basedir + "/" + folder)
    end
  end

  # TODO Rename to RubyGemProjectReporter. we might add a "java" project reporter at some point 1 day ;-)
  class RubyProjectReporter < ProjectReporterBase    
    def initialize(project_path)
      super(basename_of_directory(project_path))
      @simian_runner.basedir = project_path      
    end
    
    def configure_simian        
      # Only add the "lib" directoy if exists
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("lib")
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("test") if folder_exists?("test")
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("spec") if folder_exists?("spec")
    end    
  end

  class RailsProjectReporter < RubyProjectReporter
    def configure_simian
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("app")
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("lib")
      @simian_runner.add_html_directory_to_search_for_duplicate_lines("app/views")
    end
  end

  class RailsPluginProjectReporter < ProjectReporterBase
    def initialize(plugin_name)
      super(plugin_name )
    end

    def configure_simian
      @simian_runner.basedir = "#{RAILS_ROOT}/vendor/plugins/#{@name}"
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("lib")
      #      @project_name = project_basename + " plugin"
    end
  end
  
end  
