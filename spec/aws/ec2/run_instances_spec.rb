require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.run_instances' do

  after(:all) do
    ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes" do
    actual = ec2.run_instances('ami-5ee70037', 1, 1)
    @instance_id = actual.body[:instances_set].first[:instance_id]
    actual.body[:group_set].should be_an(Array)
    actual.body[:group_set].first.should be_a(String)
    actual.body[:instances_set].should be_an(Array)
    instance = actual.body[:instances_set].first
    instance[:ami_launch_index].should be_a(String)
    instance[:dns_name].should be_a(String)
    instance[:image_id].should be_a(String)
    instance[:instance_id].should be_a(String)
    instance[:instance_state].should be_an(Hash)
    instance[:instance_state][:code].should be_an(Integer)
    instance[:instance_state][:name].should be_an(String)
    instance[:instance_type].should be_a(String)
    # instance[:key_name].should be_a(String)
    instance[:launch_time].should be_a(Time)
    instance[:monitoring].should be_a(Hash)
    [false, true].should include(instance[:monitoring][:state])
    instance[:placement].should be_a(Hash)
    instance[:placement][:availability_zone].should be_a(String)
    instance[:private_dns_name].should be_a(String)
    instance[:reason].should be_a(String)
    actual.body[:owner_id].should be_a(String)
    actual.body[:request_id].should be_a(String)
    actual.body[:reservation_id].should be_a(String)
  end

end
