require File.dirname(__FILE__) + '/spec_helper'

describe "should eventually { block }" do

  it "should pass if block returns true immediately" do
    lambda { true }.should eventually { |expected| expected.should == true }
  end

  it "should pass if block returns true after a delay" do
    eventually = EventualMock.new(true, 1)
    lambda { true }.should eventually { |expected| expected.should == eventually.test }
  end

  it "should fail if block returns false despite delay" do
    lambda { 
      lambda { true }.should eventually { |expected| expected.should == false }
    }.should raise_error(Spec::Expectations::ExpectationNotMetError)
  end

end

describe "should_not eventually { block }" do

  it "should pass if block returns false immediately" do
    lambda { true }.should_not eventually { |expected| expected.should_not == false }
  end

  it "should pass if block returns false after a delay" do
    eventually = EventualMock.new(false, 1)
    lambda { true }.should_not eventually { |expected| expected.should_not == eventually.test }
  end

  it "should fail if block returns true despite delay" do
    lambda {
      lambda { true }.should_not eventually { |expected| expected.should_not == true }
    }.should raise_error(Spec::Expectations::ExpectationNotMetError)
  end

end
