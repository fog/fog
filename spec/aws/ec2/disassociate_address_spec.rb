require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.disassociate_address' do

  before(:all) do
    @instance_id = ec2.run_instances('ami-5ee70037', 1, 1).body[:instances_set].first[:instance_id]
    @public_ip = ec2.allocate_address.body[:public_ip]
    ec2.associate_address(@instance_id, @public_ip)
  end

  after(:all) do
    ec2.release_address(@public_ip)
    ec2.terminate_instances([@instance_id])
  end

  it "should return proper attributes" do
    actual = ec2.disassociate_address(@public_ip)
    actual.body[:request_id].should be_a(String)
    [false, true].should include(actual.body[:return])
  end

end