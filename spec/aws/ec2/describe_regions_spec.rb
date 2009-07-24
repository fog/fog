require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_availability_zones' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_regions
    zone = actual.body[:region_info].first
    zone[:region_endpoint].should be_a(String)
    zone[:region_name].should be_a(String)
  end

  it "should return proper attribute with params" do
    actual = ec2.describe_regions(['us-east-1'])
    zone = actual.body[:region_info].first
    zone[:region_endpoint].should be_a(String)
    zone[:region_name].should be_a(String)
  end

end
