require File.dirname(__FILE__) + '/../lib/rails_reporter'

namespace :dry do      
  namespace :report do
   
    reporter = DontRepeatYourself::RailsProjectReporter.new    
    
    # TODO Should be configurable with a yml file
    simian_html_report = RAILS_ROOT + "/DRY_report.html"      
    
    [DontRepeatYourself::DEFAULT_REPORT, DontRepeatYourself::NETBEANS_REPORT].each do |report_type|
      desc eval("DontRepeatYourself::#{report_type.upcase}_REPORT_DESC")
      task report_type.downcase do 
        puts reporter.send("with_#{report_type.downcase}_reporting").report
      end
    end
    
    [DontRepeatYourself::HTML_REPORT, DontRepeatYourself::TEXTMATE_REPORT].each do |report_type|
      desc eval("DontRepeatYourself::#{report_type.upcase}_REPORT_DESC")
      task report_type.downcase do 
        report = reporter.send("with_#{report_type.downcase}_reporting").report
        open(simian_html_report, 'w') { |f| f << report } 
      end
    end                                
                    
  end
  
  desc 'Copy the DRYreport to the CruiseControl.rb build artefacts folder'
  task :cruise_control_artefact => "dry:report:html" do
    out = ENV['CC_BUILD_ARTIFACTS']
    system "mv DRY_report.html #{out}/"   
  end

end