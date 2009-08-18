require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_instances' do

  before(:all) do
    run_instances = ec2.run_instances('ami-5ee70037', 1, 1).body
    @instance_id = run_instances['instancesSet'].first['instanceId']
    @reservation_id = run_instances['reservationId']
  end

  after(:all) do
    ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes with no params" do
    actual = ec2.describe_instances
    reservation = actual.body['reservationSet'].select {|reservation| reservation['reservationId'] == @reservation_id}.first
    reservation['groupSet'].should be_an(Array)
    reservation['groupSet'].first.should be_a(String)
    reservation['ownerId'].should be_a(String)
    reservation['reservationId'].should be_a(String)
    instance = reservation['instancesSet'].select {|instance| instance['instanceId'] == @instance_id}.first
    instance['amiLaunchIndex'].should be_an(Integer)
    instance['dnsName'].should be_a(String)
    instance['imageId'].should be_a(String)
    instance['instanceId'].should be_a(String)
    instance['instanceState'].should be_a(Hash)
    instance['instanceState']['code'].should be_a(String)
    instance['instanceState']['name'].should be_a(String)
    instance['instanceType'].should be_a(String)
    instance['kernelId'].should be_a(String)
    instance['keyName'].should be_a(String) if instance['keyName']
    instance['launchTime'].should be_a(Time)
    instance['monitoring'].should be_a(Hash)
    [true, false].should include(instance['monitoring']['state'])
    instance['placement'].should be_an(Array)
    instance['placement'].first.should be_a(String)
    instance['privateDnsName'].should be_a(String)
    instance['productCodes'].should be_an(Array)
    instance['productCodes'].first.should be_a(String) if instance['productCodes'].first
    instance['ramdiskId'].should be_a(String)
    instance['reason'].should be_a(String)
  end
  
  it "should return proper attributes with params" do
    actual = ec2.describe_instances(@instance_id)
    reservation = actual.body['reservationSet'].select {|reservation| reservation['reservationId'] == @reservation_id}.first
    reservation['groupSet'].should be_an(Array)
    reservation['groupSet'].first.should be_a(String)
    reservation['ownerId'].should be_a(String)
    reservation['reservationId'].should be_a(String)
    instance = reservation['instancesSet'].select {|instance| instance['instanceId'] == @instance_id}.first
    instance['amiLaunchIndex'].should be_an(Integer)
    instance['dnsName'].should be_a(String)
    instance['imageId'].should be_a(String)
    instance['instanceId'].should be_a(String)
    instance['instanceState'].should be_a(Hash)
    instance['instanceState']['code'].should be_a(String)
    instance['instanceState']['name'].should be_a(String)
    instance['instanceType'].should be_a(String)
    instance['kernelId'].should be_a(String)
    instance['keyName'].should be_a(String) if instance['keyName']
    instance['launchTime'].should be_a(Time)
    instance['monitoring'].should be_a(Hash)
    [true, false].should include(instance['monitoring']['state'])
    instance['placement'].should be_an(Array)
    instance['placement'].first.should be_a(String)
    instance['privateDnsName'].should be_a(String)
    instance['productCodes'].should be_an(Array)
    instance['productCodes'].first.should be_a(String) if instance['productCodes'].first
    instance['ramdiskId'].should be_a(String)
    instance['reason'].should be_a(String)
  end

end
