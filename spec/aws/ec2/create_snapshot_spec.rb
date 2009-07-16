require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_snapshot' do

  before(:all) do
    @volume_id = ec2.create_volume('us-east-1a', 1).body[:volume_id]
  end

  after(:all) do
    ec2.delete_volume(@volume_id)
    ec2.delete_snapshot(@snapshot_id)
  end

  it "should return proper attributes" do
    actual = ec2.create_snapshot(@volume_id)
    actual.body[:progress].should be_a(String)
    @snapshot_id = actual.body[:snapshot_id]
    actual.body[:snapshot_id].should be_a(String)
    actual.body[:start_time].should be_a(Time)
    actual.body[:status].should be_a(String)
    actual.body[:volume_id].should be_a(String)
  end

end
