Feature: DRY Reports on Textmate, Netbeans, plain text and HTML
  In order to improve the quality of my code by removing & refactoring dupplication
  As a Ruby programmer
  I want to generate DRY reports with a list of duplicates lines in my projects which play well with my IDE  
  
  Scenario: Textmate integration
    Given I am working on a Ruby project dummy whose base directory is dummy_rails_app
    Given my IDE is Textmate
    When I generate a DRY HTML report and click on the link of a duplicate line
    Then it should open automatically Textmate with the class which contain the duplication and go to the line number where duplication starts