require File.dirname(__FILE__) + '/reporter'
require 'optparse'

module DontRepeatYourself
  class CLI
           
    class << self
    
      def execute
        parse(ARGV).execute!
      end
      
      def parse(args)
        cli = new
        cli.parse_options!(args)
        cli
      end
    end
    
    attr_reader :options
    FORMATS = DontRepeatYourself::REPORT_TYPES.map{|format| format.downcase}
    REPORTERS = DontRepeatYourself::REPORTER_TYPES.map{|reporter| reporter.downcase}

    def initialize
      
    end

    def parse_options!(args)
      args.extend(OptionParser::Arguable)

      @options = { :basedir => './', :format => 'default', :reporter => 'ruby' }
      args.options do |opts|
        opts.banner = "Usage: dry-report [options] "
        
        opts.on("-d BASEDIR", "--basedir BASEDIR", "set up the base directory of your ruby project, current directory by default") do |b|
          @options[:basedir] = b
        end
        
        opts.on("-f FORMAT", "--format FORMAT", "report format (default is plain text)",
          "Available formats: #{FORMATS.join(", ")}") do |v|
          unless FORMATS.index(v) 
            STDERR.puts "Invalid format: #{v}\n"
            STDERR.puts opts.help
            exit 1
          end
          @options[:format] = v
        end
                
        opts.on("-t THRESHOLD", "--threshold THRESHOLD", "threshold of duplicate lines") do |t|
          @options[:threshold] = t.to_i
        end
       
        opts.on("-r REPORTER", "--reporter REPORTER", "reporter to use (default is ruby): ruby, rails, or plugin",
          "Available reporters: #{REPORTERS.join(", ")}") do |v|
          unless REPORTERS.index(v) 
            STDERR.puts "Invalid reporter: #{v}\n"
            STDERR.puts opts.help
            exit 1
          end
          @options[:reporter] = v
        end

        opts.on_tail("--help", "You're looking at it. Any question? http://21croissants.blogspot.com/2008/10/dry.html") do
          puts opts.help
          exit
        end
      end.parse!
            
    end
            
    def execute!
      ruby_project_reporter = DontRepeatYourself::ProjectReporterBase.build_reporter(@options[:reporter], @options[:basedir])
      ruby_project_reporter.with_threshold_of_duplicate_lines(@options[:threshold]) if @options.has_key?(:threshold)
      ruby_project_reporter.send("with_#{@options[:format]}_reporting") if @options.has_key?(:format)      
      STDOUT.print(ruby_project_reporter.report)
    end
  end # class 
  
end
