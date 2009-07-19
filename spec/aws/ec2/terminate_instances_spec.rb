require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.terminate_instances' do

  before(:all) do
    @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body[:instances_set].first[:instance_id]
  end

  it "should return proper attributes" do
    actual = ec2.terminate_instances([@instance_id])
    actual.body[:request_id].should be_a(String)
    actual.body[:instances_set].should be_an(Array)
    instance = actual.body[:instances_set].select {|instance| instance[:instance_id] == @instance_id}.first
    instance[:previous_state].should be_a(Hash)
    previous_state = instance[:previous_state]
    previous_state[:code].should be_a(Integer)
    previous_state[:name].should be_a(String)
    instance[:shutdown_state].should be_a(Hash)
    shutdown_state = instance[:shutdown_state]
    shutdown_state[:code].should be_a(Integer)
    shutdown_state[:name].should be_a(String)
  end

end
