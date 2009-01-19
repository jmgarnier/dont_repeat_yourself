require 'yaml'

module DontRepeatYourself
  
  # See Simian doc in http://www.redhillconsulting.com.au/products/simian/installation.html#cli
  class SimianRunner
    
    attr_reader :basedir,
                :patterns_of_directories_to_search_for_duplicate_lines,
                :formatter_option,
                :simian_jar_path,
                :executable,
                :simian_log_file,
                :threshold
    
    DEFAULT_THRESHOLD = 3
    SIMIAN_LOGFILE_NAME = "simian_log.yaml"
      
    def initialize()
      @threshold = DEFAULT_THRESHOLD
      @patterns_of_directories_to_search_for_duplicate_lines, @patterns_of_directories_to_exclude_for_duplicate_lines = [], []
      @formatter_option = "-formatter=yaml"
      
      # extension is .txt because the selenium_on_rails project had a problem with jar files that could be
      # downloaded from the rubygems repository
      # In order to prevent this kind of problem, I decided to use another suffix as they did ...
      @simian_jar_path = File.join(File.dirname(__FILE__), '..', 'jars', 'simian-2.2.24.jar.xyz')
      
      @executable = "java -jar #{@simian_jar_path}".freeze
            
    end
    
    def threshold=(threshold)
      raise ArgumentError.new("Error: Threshold can't be less that 2") if threshold < 2
      @threshold = threshold
    end
    
    def basedir=(basedir)
      # TODO Check if Validatable has some generic code for this. I keep copy-pasting here !!!
      raise ArgumentError.new(basedir << " does not exist") if !File.directory?(basedir)
      @basedir = basedir
      @simian_log_file = @basedir + "/" + DontRepeatYourself::SimianRunner::SIMIAN_LOGFILE_NAME
    end
    
    def add_ruby_directory_to_search_for_duplicate_lines(path)
      valid_directory_path(path)
      # TODO if the next line usefull ?
      @patterns_of_directories_to_search_for_duplicate_lines << (path + "/*.rb")
      @patterns_of_directories_to_search_for_duplicate_lines << (path + "/**/*.rb")
    end       
    
    def add_html_directory_to_search_for_duplicate_lines(path)
      valid_directory_path(path)
      @patterns_of_directories_to_search_for_duplicate_lines << (path + "/**/*.*html")
    end  
    
    def ignore_file(path)
      valid_file_path(path)
      @patterns_of_directories_to_exclude_for_duplicate_lines << "/" + path
    end

    def ignore_directory(path)
      valid_directory_path(path)
      @patterns_of_directories_to_exclude_for_duplicate_lines << add_ruby_pattern(path)
    end
    
    def run      
      run_java
      results_yaml = YAML.load(simian_output_with_header_removed)
      delete_simian_log_file
      results_yaml
    end        
    
    private

    def add_ruby_pattern(path)
      "#{path}/**/*.rb"
    end

    def parameter_threshold
      "-threshold=#{@threshold}"
    end
    
    def parameter_includes
      generate_commandline_parameter("includes", @patterns_of_directories_to_search_for_duplicate_lines)
    end   
    
    def parameter_excludes
      generate_commandline_parameter("excludes", @patterns_of_directories_to_exclude_for_duplicate_lines)
    end
    
    def generate_commandline_parameter(paramater_name, parameter_list) 
      parameter_list.map { |pattern| 
        "-#{paramater_name}=#{File.join(@basedir, pattern)}" 
      } * ' '
    end
    
    def command_line
      "#{@executable} #{parameter_threshold} #{@formatter_option} #{parameter_includes} #{parameter_excludes} > #{@simian_log_file}"      
    end
    
    # TODO Add return code processing
    def run_java
      system(command_line)
    end
    
    def simian_output_with_header_removed
      # Remove the Simian text header
      log = IO.read(@simian_log_file)
      log[/simian:.*/m] # m <=> Multiline mode
    end
    
    def delete_simian_log_file
      File.delete @simian_log_file if File.file?(@simian_log_file)
    end
    
    def valid_directory_path(path)
      absolute_path = File.join(@basedir, "/" + path)
      if !File.directory?(absolute_path)
        raise ArgumentError.new(absolute_path << " does not exist, path should be relative to #{@basedir} and not start neither end with '/' ") 
      end
      absolute_path
    end        
    
    def valid_file_path(path)
      absolute_path = File.join(@basedir, "/" + path)
      if !File.file?(absolute_path)
        raise ArgumentError.new(absolute_path << " file does not exist, path should be relative to #{@basedir} and not start neither end with '/' ") 
      end
      absolute_path
    end 
    
  end
  
end