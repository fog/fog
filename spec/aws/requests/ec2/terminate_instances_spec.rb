require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.terminate_instances' do
  describe 'success' do

    before(:each) do
      @instance_id = AWS[:ec2].run_instances(GENTOO_AMI, 1, 1).body['instancesSet'].first['instanceId']
    end

    it "should return proper attributes" do
      actual = AWS[:ec2].terminate_instances(@instance_id)
      actual.body['requestId'].should be_a(String)
      actual.body['instancesSet'].should be_an(Array)
      instance = actual.body['instancesSet'].select {|instance| instance['instanceId'] == @instance_id}.first
      instance['previousState'].should be_a(Hash)
      previous_state = instance['previousState']
      previous_state['code'].should be_a(Integer)
      previous_state['name'].should be_a(String)
      instance['currentState'].should be_a(Hash)
      current_state = instance['currentState']
      current_state['code'].should be_a(Integer)
      current_state['name'].should be_a(String)
    end

  end
  describe 'failure' do

    it 'should raise a BadRequest error if the instance does not exist' do
      lambda {
        AWS[:ec2].terminate_instances('i-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
