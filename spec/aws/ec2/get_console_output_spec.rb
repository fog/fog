require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.get_console_output' do

  before(:all) do
    @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body[:instances_set].first[:instance_id]
  end

  after(:all) do
    ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes" do
    actual = ec2.get_console_output(@instance_id)
    p actual
    # actual.body[:instance_id].should be_a(String)
    # actual.body[:output].should be_a(String)
    # actual.body[:request_id].should be_a(String)
    # actual.body[:timestamp].should be_a(Time)
  end

end
