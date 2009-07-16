require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_security_groups' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_security_groups
    actual.security_group_info.should be_an(Array)
    p actual
  end
  
  it "should return proper attributes with params"

end
