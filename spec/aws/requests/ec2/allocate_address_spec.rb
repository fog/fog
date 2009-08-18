require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.allocate_address' do

  after(:all) do
    ec2.release_address(@public_ip)
  end

  it "should return proper attributes" do
    actual = ec2.allocate_address
    actual.body['requestId'].should be_a(String)
    @public_ip = actual.body['publicIp']
    actual.body['publicIp'].should be_a(String)
  end

end
