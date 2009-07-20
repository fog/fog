require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_instances' do

  before(:all) do
    run_instances = ec2.run_instances('ami-5ee70037', 1, 1).body
    @instance_id = run_instances[:instances_set].first[:instance_id]
    @reservation_id = run_instances[:reservation_id]
  end

  after(:all) do
    ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes with no params" do
    actual = ec2.describe_instances
    p actual
    # reservation = actual.body[:reservation_set].select {|reservation| reservation[:reservation_id] == @reservation_id}
    # instance = reservation[:instances_set].select {|instance| instance[:instance_id] == @instance_id}
  end
  
  it "should return proper attributes with params"

end
