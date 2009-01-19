require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/interop/test'

describe "Test::Unit extension" do

  before :each do
    @this_project = this_project
  end

  it "should have a custom expectation matcher be_DRY" do
    assert_dry @this_project.
        ignoring_the_file("spec/dont_repeat_yourself/formatter_spec.rb").
        ignoring_the_directory("spec/rails_webapp")
  end

end