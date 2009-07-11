require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_snapshots' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_snapshots
    p actual
  end
  
  it "should return proper attributes with params"

end
