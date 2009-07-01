require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_addresses' do

  before(:all) do
    @public_ip = ec2.allocate_address
  end

  after(:all) do
    ec2.release_address(@public_ip)
  end

  it "should return proper attributes" do
    actual = ec2.describe_addresses(@public_ip)
    item = actual.body[:addresses].select {|address| address[:public_ip] == @public_ip}
    item.should_not be_nil
    p actual
  end

end
