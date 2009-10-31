require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_addresses' do
  describe 'success' do

    before(:each) do
      @public_ip = ec2.allocate_address.body['publicIp']
    end

    after(:each) do
      ec2.release_address(@public_ip)
    end

    it "should return proper attributes with no params" do
      actual = ec2.describe_addresses
      actual.body['requestId'].should be_a(String)
      item = actual.body['addressesSet'].select {|address| address['publicIp'] == @public_ip}
      item.should_not be_nil
    end

    it "should return proper attributes for specific ip" do
      actual = ec2.describe_addresses(@public_ip)
      actual.body['requestId'].should be_a(String)
      item = actual.body['addressesSet'].select {|address| address['publicIp'] == @public_ip}
      item.should_not be_nil
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if ip does not exist" do
      lambda {
        ec2.describe_addresses('127.0.0.1')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
