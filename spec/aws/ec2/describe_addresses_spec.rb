require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_addresses' do

  before(:all) do
    @public_ip = ec2.allocate_address.body['publicIp']
  end

  after(:all) do
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
