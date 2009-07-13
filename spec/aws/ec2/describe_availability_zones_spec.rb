require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_availability_zones' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_availability_zones
    zone = actual.body[:availability_zone_info].first
    zone[:region_name].should be_a(String)
    zone[:zone_name].should be_a(String)
    zone[:zone_state].should be_a(String)
  end

  it "should return proper attributes for specific ip"

end
