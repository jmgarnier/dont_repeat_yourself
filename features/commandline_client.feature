Feature: Run dry-report from the command line for a Ruby project
  As a Ruby programmer
  I want to generate the DRY report from the command line
  So that I can run it on any project very quickly and integrate it in my Continuous Integration report
  
  Scenario: Generating a text report on dry-report when current directory is the basedir of the dry-report gem
    Given the current directory is ./
    When I execute dry-report
    Then it should output a text report in the directory ./

  Scenario: Generating a text report on dry-report when current directory is the dummy Rails app
    Given the current directory is ./
    When I execute dry-report --basedir ./dummy_rails_app 
    Then it should output a text report in the directory ./