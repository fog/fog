require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_instances' do

  before(:all) do
    run_instances = ec2.run_instances('ami-5ee70037', 1, 1).body
    @instance_id = run_instances[:instances_set].first[:instance_id]
    @reservation_id = run_instances[:reservation_id]
  end

  after(:all) do
    ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes with no params" do
    actual = ec2.describe_instances
    reservation = actual.body[:reservation_set].select {|reservation| reservation[:reservation_id] == @reservation_id}.first
    reservation[:group_set].should be_an(Array)
    reservation[:group_set].first.should be_a(String)
    reservation[:owner_id].should be_a(String)
    reservation[:reservation_id].should be_a(String)
    instance = reservation[:instances_set].select {|instance| instance[:instance_id] == @instance_id}.first
    instance[:ami_launch_index].should be_an(Integer)
    instance[:dns_name].should be_a(String)
    instance[:image_id].should be_a(String)
    instance[:instance_id].should be_a(String)
    instance[:instance_state].should be_a(Hash)
    state = instance[:instance_state]
    state[:code].should be_a(String)
    state[:name].should be_a(String)
    instance[:instance_type].should be_a(String)
    instance[:kernel_id].should be_a(String)
    # instance[:key_name].should be_a(String)
    instance[:launch_time].should be_a(Time)
    instance[:monitoring].should be_a(Hash)
    [true, false].should include(instance[:monitoring][:state])
    instance[:placement].should be_an(Array)
    instance[:placement].first.should be_a(String)
    instance[:private_dns_name].should be_a(String)
    instance[:product_codes].should be_an(Array)
    # instance[:product_codes].first.should be_a(String)
    instance[:ramdisk_id].should be_a(String)
    instance[:reason].should be_a(String)
  end
  
  it "should return proper attributes with params" do
    actual = ec2.describe_instances(@instance_id)
    reservation = actual.body[:reservation_set].select {|reservation| reservation[:reservation_id] == @reservation_id}.first
    reservation[:group_set].should be_an(Array)
    reservation[:group_set].first.should be_a(String)
    reservation[:owner_id].should be_a(String)
    reservation[:reservation_id].should be_a(String)
    instance = reservation[:instances_set].select {|instance| instance[:instance_id] == @instance_id}.first
    instance[:ami_launch_index].should be_an(Integer)
    instance[:dns_name].should be_a(String)
    instance[:image_id].should be_a(String)
    instance[:instance_id].should be_a(String)
    instance[:instance_state].should be_a(Hash)
    state = instance[:instance_state]
    state[:code].should be_a(String)
    state[:name].should be_a(String)
    instance[:instance_type].should be_a(String)
    instance[:kernel_id].should be_a(String)
    # instance[:key_name].should be_a(String)
    instance[:launch_time].should be_a(Time)
    instance[:monitoring].should be_a(Hash)
    [true, false].should include(instance[:monitoring][:state])
    instance[:placement].should be_an(Array)
    instance[:placement].first.should be_a(String)
    instance[:private_dns_name].should be_a(String)
    instance[:product_codes].should be_an(Array)
    # instance[:product_codes].first.should be_a(String)
    instance[:ramdisk_id].should be_a(String)
    instance[:reason].should be_a(String)
  end

end
