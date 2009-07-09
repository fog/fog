require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_instances' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_instances
    p actual
  end
  
  it "should return proper attributes with params"

end
