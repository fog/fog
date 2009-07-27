require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.detach_volume' do

  before(:all) do
    @instance_id = ec2.run_instances('ami-5ee70037', 1, 1, {:availability_zone => 'us-east-1a'}).body[:instances_set].first[:instance_id]
    @volume_id = ec2.create_volume('us-east-1a', 1).body[:volume_id]
    eventually(128) do
      ec2.attach_volume(@volume_id, @instance_id, '/dev/sdh')
    end
  end

  after(:all) do
    eventually do
      ec2.delete_volume(@volume_id)
      ec2.terminate_instances([@instance_id])
    end
  end

  it "should return proper attributes" do
    eventually do
      actual = ec2.detach_volume(@volume_id)
      actual.body[:attach_time].should be_a(Time)
      actual.body[:device].should be_a(String)
      actual.body[:instance_id].should be_a(String)
      actual.body[:request_id].should be_a(String)
      actual.body[:status].should be_a(String)
      actual.body[:volume_id].should be_a(String)
    end
  end

end