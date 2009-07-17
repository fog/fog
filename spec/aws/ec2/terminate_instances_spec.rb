require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.terminate_instances' do

  before(:all) do
    @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body[:instance_set].first[:instance_id]
  end

  it "should return proper attributes" do
    actual = ec2.terminate_instances([@instance_id])
    p actual
  end

end
