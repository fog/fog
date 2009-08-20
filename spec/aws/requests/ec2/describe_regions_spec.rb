require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_availability_zones' do
  describe 'success' do

    it "should return proper attributes with no params" do
      actual = ec2.describe_regions
      zone = actual.body['regionInfo'].first
      zone['regionEndpoint'].should be_a(String)
      zone['regionName'].should be_a(String)
    end

    it "should return proper attribute with params" do
      actual = ec2.describe_regions(['us-east-1'])
      zone = actual.body['regionInfo'].first
      zone['regionEndpoint'].should be_a(String)
      zone['regionName'].should be_a(String)
    end

  end
end
