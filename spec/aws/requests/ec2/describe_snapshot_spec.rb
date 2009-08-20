require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_snapshots' do
  describe 'success' do

    before(:each) do
      @volume_id = ec2.create_volume('us-east-1a', 1).body['volumeId']
      @snapshot_id = ec2.create_snapshot(@volume_id).body['snapshotId']
    end

    after(:each) do
      ec2.delete_volume(@volume_id)
      eventually do
        ec2.delete_snapshot(@snapshot_id)
      end
    end

    it "should return proper attributes with no params" do
      eventually do
        actual = ec2.describe_snapshots
        actual.body['snapshotSet'].should be_an(Array)
        snapshot = actual.body['snapshotSet'].select {|snapshot| snapshot['snapshotId'] == @snapshot_id}.first
        snapshot['progress'].should be_a(String)
        snapshot['snapshotId'].should be_a(String)
        snapshot['startTime'].should be_a(Time)
        snapshot['status'].should be_a(String)
        snapshot['volumeId'].should be_a(String)
      end
    end
  
    it "should return proper attributes with params" do
      eventually do
        actual = ec2.describe_snapshots([@snapshot_id])
        actual.body['snapshotSet'].should be_an(Array)
        snapshot = actual.body['snapshotSet'].select {|snapshot| snapshot['snapshotId'] == @snapshot_id}.first
        snapshot['progress'].should be_a(String)
        snapshot['snapshotId'].should be_a(String)
        snapshot['startTime'].should be_a(Time)
        snapshot['status'].should be_a(String)
        snapshot['volumeId'].should be_a(String)
      end
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the snapshot does not exist" do
      lambda {
        ec2.describe_snapshots('snap-00000000')
      }.should raise_error(Fog::Errors::BadRequest)
    end

  end
end
