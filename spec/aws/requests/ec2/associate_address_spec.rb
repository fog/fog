require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.associate_address' do
  describe 'success' do

    before(:each) do
      @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body['instancesSet'].first['instanceId']
      @public_ip = ec2.allocate_address.body['publicIp']
    end

    after(:each) do
      ec2.release_address(@public_ip)
      ec2.terminate_instances(@instance_id)
    end

    it "should return proper attributes" do
      actual = ec2.associate_address(@instance_id, @public_ip)
      actual.body['requestId'].should be_a(String)
      [false, true].should include(actual.body['return'])
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the instance does not exist" do
      @public_ip = ec2.allocate_address.body['publicIp']
      lambda {
        ec2.associate_address('i-00000000', @public_ip)
      }.should raise_error(Fog::Errors::BadRequest)
      ec2.release_address(@public_ip)
    end

    it "should raise a BadRequest error if the address does not exist" do
      @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body['instancesSet'].first['instanceId']
      lambda {
        ec2.associate_address(@instance_id, '127.0.0.1')
      }.should raise_error(Fog::Errors::BadRequest)
      ec2.terminate_instances(@instance_id)
    end

  end
end