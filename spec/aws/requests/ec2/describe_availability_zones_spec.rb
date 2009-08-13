require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_availability_zones' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_availability_zones
    zone = actual.body['availabilityZoneInfo'].first
    zone['regionName'].should be_a(String)
    zone['zoneName'].should be_a(String)
    zone['zoneState'].should be_a(String)
  end

  it "should return proper attribute with params" do
    actual = ec2.describe_availability_zones(['us-east-1a'])
    zone = actual.body['availabilityZoneInfo'].first
    zone['regionName'].should be_a(String)
    zone['zoneName'].should be_a(String)
    zone['zoneState'].should be_a(String)
  end

end
