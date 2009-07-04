require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_security_groups' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_security_groups
    p actual
  end
  
  it "should return proper attributes with params"

end
