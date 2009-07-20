require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_snapshots' do

  before(:all) do
    @volume_id = ec2.create_volume('us-east-1a', 1).body[:volume_id]
    @snapshot_id = ec2.create_snapshot(@volume_id).body[:snapshot_id]
  end

  after(:all) do
    ec2.delete_volume(@volume_id)
    eventually do
      ec2.delete_snapshot(@snapshot_id)
    end
  end

  it "should return proper attributes with no params" do
    eventually do
      actual = ec2.describe_snapshots
      actual.body[:snapshot_set].should be_an(Array)
      snapshot = actual.body[:snapshot_set].select {|snapshot| snapshot[:snapshot_id] == @snapshot_id}.first
      snapshot[:progress].should be_a(String)
      snapshot[:snapshot_id].should be_a(String)
      snapshot[:start_time].should be_a(Time)
      snapshot[:status].should be_a(String)
      snapshot[:volume_id].should be_a(String)
    end
  end
  
  it "should return proper attributes with params" do
    eventually do
      actual = ec2.describe_snapshots([@snapshot_id])
      actual.body[:snapshot_set].should be_an(Array)
      snapshot = actual.body[:snapshot_set].select {|snapshot| snapshot[:snapshot_id] == @snapshot_id}.first
      snapshot[:progress].should be_a(String)
      snapshot[:snapshot_id].should be_a(String)
      snapshot[:start_time].should be_a(Time)
      snapshot[:status].should be_a(String)
      snapshot[:volume_id].should be_a(String)
    end
  end

end
