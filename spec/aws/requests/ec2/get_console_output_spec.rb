require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.get_console_output' do
  describe 'success' do

    before(:each) do
      @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body['instancesSet'].first['instanceId']
    end

    after(:each) do
      ec2.terminate_instances([@instance_id])
    end

    it "should return proper attributes" do
      actual = ec2.get_console_output(@instance_id)
      actual.body['instanceId'].should be_a(String)
      actual.body['output'].should be_a(String)
      actual.body['requestId'].should be_a(String)
      actual.body['timestamp'].should be_a(Time)
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the instance does not exist" do
      lambda {
        ec2.get_console_output('i-00000000')
      }.should raise_error(Fog::Errors::BadRequest)
    end

  end
end
