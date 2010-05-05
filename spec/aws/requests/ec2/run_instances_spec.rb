require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.run_instances' do
  describe 'success' do

    after(:each) do
      AWS[:ec2].terminate_instances(@instance_id)
    end

    it "should return proper attributes" do
      # ami-5ee70037 = gentoo
      actual = AWS[:ec2].run_instances(GENTOO_AMI, 1, 1)
      @instance_id = actual.body['instancesSet'].first['instanceId']
      actual.body['groupSet'].should be_an(Array)
      actual.body['groupSet'].first.should be_a(String)
      actual.body['instancesSet'].should be_an(Array)
      instance = actual.body['instancesSet'].first
      instance['amiLaunchIndex'].should be_a(Integer)
      # instance['architecture'].should be_a(String)
      instance['blockDeviceMapping'].should be_an(Array)
      instance['dnsName'].should be_nil
      instance['imageId'].should be_a(String)
      instance['instanceId'].should be_a(String)
      instance['instanceState'].should be_an(Hash)
      instance['instanceState']['code'].should be_an(Integer)
      instance['instanceState']['name'].should be_an(String)
      instance['instanceType'].should be_a(String)
      # instance['ipAddress'].should be_a(String)
      instance['kernelId'].should be_a(String)
      instance['keyName'].should be_a(String) if instance['keyName']
      instance['launchTime'].should be_a(Time)
      instance['monitoring'].should be_a(Hash)
      [false, true].should include(instance['monitoring']['state'])
      instance['placement'].should be_a(Hash)
      instance['placement']['availabilityZone'].should be_a(String)
      instance['privateDnsName'].should be_nil
      # instance['privateIpAddress'].should be_a(String)
      instance['ramdiskId'].should be_a(String)
      instance['reason'].should be_nil
      actual.body['ownerId'].should be_a(String)
      actual.body['requestId'].should be_a(String)
      actual.body['reservationId'].should be_a(String)
      # instance['rootDeviceName'].should be_a(String)
      instance['rootDeviceType'].should be_a(String)
    end

  end
end
