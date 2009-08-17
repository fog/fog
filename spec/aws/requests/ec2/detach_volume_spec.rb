require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.detach_volume' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @instance_id = @ec2.run_instances('ami-5ee70037', 1, 1, {'Placement.AvailabilityZone' => 'us-east-1a'}).body['instancesSet'].first['instanceId']
    @volume_id = @ec2.create_volume('us-east-1a', 1).body['volumeId']
    eventually(128) do
      @ec2.attach_volume(@volume_id, @instance_id, '/dev/sdh')
    end
  end

  after(:all) do
    eventually do
      @ec2.delete_volume(@volume_id)
      @ec2.terminate_instances([@instance_id])
    end
  end

  it "should return proper attributes" do
    eventually do
      actual = @ec2.detach_volume(@volume_id)
      actual.body['attachTime'].should be_a(Time)
      actual.body['device'].should be_a(String)
      actual.body['instanceId'].should be_a(String)
      actual.body['requestId'].should be_a(String)
      actual.body['status'].should be_a(String)
      actual.body['volumeId'].should be_a(String)
    end
  end

end