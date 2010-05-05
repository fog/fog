require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.get_console_output' do
  describe 'success' do

    before(:each) do
      @instance_id = AWS[:ec2].run_instances(GENTOO_AMI, 1, 1).body['instancesSet'].first['instanceId']
      AWS[:ec2].servers.get(@instance_id).wait_for { ready? }
    end

    after(:each) do
      AWS[:ec2].terminate_instances([@instance_id])
    end

    it "should return proper attributes" do
      actual = AWS[:ec2].get_console_output(@instance_id).body
      actual['instanceId'].should be_a(String)
      if actual['output']
        actual['output'].should be_a(String)
      end
      actual['requestId'].should be_a(String)
      actual['timestamp'].should be_a(Time)
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the instance does not exist" do
      lambda {
        AWS[:ec2].get_console_output('i-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
