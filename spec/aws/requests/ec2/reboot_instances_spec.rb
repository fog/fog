require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.reboot_instances' do
  describe 'success' do

    before(:each) do
      @instance_id = ec2.run_instances(GENTOO_AMI, 1, 1).body['instancesSet'].first['instanceId']
    end

    after(:each) do
      ec2.terminate_instances(@instance_id)
    end

    it "should return proper attributes" do
      actual = ec2.reboot_instances(@instance_id)
      actual.body['requestId'].should be_a(String)
      [false, true].should include(actual.body['return'])
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the instance does not exist" do
      lambda {
        ec2.reboot_instances('i-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
