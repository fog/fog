require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.disassociate_address' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @instance_id = @ec2.run_instances('ami-5ee70037', 1, 1).body['instancesSet'].first['instanceId']
    @public_ip = @ec2.allocate_address.body['publicIp']
    @ec2.associate_address(@instance_id, @public_ip)
  end

  after(:all) do
    @ec2.release_address(@public_ip)
    @ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes" do
    actual = @ec2.disassociate_address(@public_ip)
    actual.body['requestId'].should be_a(String)
    [false, true].should include(actual.body['return'])
  end

end