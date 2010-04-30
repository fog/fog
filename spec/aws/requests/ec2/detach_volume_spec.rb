require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.detach_volume' do
  describe 'success' do

    before(:each) do
      @instance_id = AWS[:ec2].run_instances(GENTOO_AMI, 1, 1, {'Placement.AvailabilityZone' => 'us-east-1a'}).body['instancesSet'].first['instanceId']
      @volume_id = AWS[:ec2].create_volume('us-east-1a', 1).body['volumeId']
      AWS[:ec2].servers.get(@instance_id).wait_for { ready? }
      AWS[:ec2].servers.get(@instance_id).wait_for { ready? }
      AWS[:ec2].attach_volume(@instance_id, @volume_id, '/dev/sdh')
      AWS[:ec2].volumes.get(@volume_id).wait_for { ready? }
    end

    after(:each) do
      AWS[:ec2].volumes.get(@volume_id).wait_for { ready? }
      AWS[:ec2].delete_volume(@volume_id)
      AWS[:ec2].terminate_instances([@instance_id])
    end

    it "should return proper attributes" do
      actual = AWS[:ec2].detach_volume(@volume_id)
      actual.body['attachTime'].should be_a(Time)
      actual.body['device'].should be_a(String)
      actual.body['instanceId'].should be_a(String)
      actual.body['requestId'].should be_a(String)
      actual.body['status'].should be_a(String)
      actual.body['volumeId'].should be_a(String)
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the volume does not exist" do
      lambda {
        AWS[:ec2].detach_volume('vol-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
