require 'dont_repeat_yourself/reporter'

module DontRepeatYourself

  # TODO Move these constans to the gem?
  ### Define methods for generating a DRY *_rails_report for Rails project where plugin is installed
  DEFAULT_REPORT_DESC   = "display the default plain report"
  NETBEANS_REPORT_DESC  = "display the report in the Output window of the Netbeans IDE (Ctrl+4)"
  HTML_REPORT_DESC      = "generate an DRY_report.html file in the project root folder"
  TEXTMATE_REPORT_DESC  = "to generate an html report with links which open files in the Textmate editor"

  class RailsProjectReporter < ProjectReporterBase
    def initialize
      super(self.project_basename)
    end
    
    def project_basename
      # FIXME
      #      @simian_log_file = RAILS_ROOT + "/simian_log.yaml"
      basename_of_directory(RAILS_ROOT)
    end
    
    def configure_simian
      @simian_runner.basedir = File.expand_path(RAILS_ROOT)
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("app")
      @simian_runner.add_ruby_directory_to_search_for_duplicate_lines("lib")
      @simian_runner.add_html_directory_to_search_for_duplicate_lines("app/views")
    end
  end
  
  class RailsPluginProjectReporter  < ProjectReporterBase
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