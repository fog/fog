require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_availability_zones' do
  describe 'success' do

    it "should return proper attributes with no params" do
      actual = AWS[:ec2].describe_availability_zones
      zone = actual.body['availabilityZoneInfo'].first
      zone['regionName'].should be_a(String)
      zone['zoneName'].should be_a(String)
      zone['zoneState'].should be_a(String)
    end

    it "should return proper attribute with params" do
      actual = AWS[:ec2].describe_availability_zones(['us-east-1a'])
      zone = actual.body['availabilityZoneInfo'].first
      zone['regionName'].should be_a(String)
      zone['zoneName'].should be_a(String)
      zone['zoneState'].should be_a(String)
    end

  end
end
