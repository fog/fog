require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.allocate_address' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
  end

  after(:all) do
    @ec2.release_address(@public_ip)
  end

  it "should return proper attributes" do
    actual = @ec2.allocate_address
    actual.body['requestId'].should be_a(String)
    @public_ip = actual.body['publicIp']
    actual.body['publicIp'].should be_a(String)
  end

end
