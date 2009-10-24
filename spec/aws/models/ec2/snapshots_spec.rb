require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Snapshots' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::Snapshots" do
      ec2.snapshots.all.should be_a(Fog::AWS::EC2::Snapshots)
    end

    it "should include persisted snapshots" do
      volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      snapshot = volume.snapshots.create
      ec2.snapshots.all.map {|snapshot| snapshot.snapshot_id}.should include(snapshot.snapshot_id)
      snapshot.destroy
      volume.destroy
    end

    it "should limit snapshots by volume_id if present" do
      volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      other_volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      snapshot = volume.snapshots.create
      other_volume.snapshots.all.map {|snapshot| snapshot.snapshot_id}.should_not include(snapshot.snapshot_id)
      snapshot.destroy
      other_volume.destroy
      volume.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      @snapshot = @volume.snapshots.create
    end

    after(:each) do
      @snapshot.destroy
      @volume.destroy
    end

    it "should return a Fog::AWS::EC2::Snapshot" do
      @snapshot.should be_a(Fog::AWS::EC2::Snapshot)
    end

    it "should exist on ec2" do
      ec2.snapshots.get(@snapshot.snapshot_id).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::Snapshot if a matching snapshot exists" do
      volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      snapshot = volume.snapshots.create
      get = ec2.snapshots.get(snapshot.snapshot_id)
      snapshot.attributes.should == get.attributes
      snapshot.destroy
    end

    it "should return nil if no matching address exists" do
      ec2.snapshots.get('vol-00000000').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::Snapshot" do
      ec2.snapshots.new.should be_a(Fog::AWS::EC2::Snapshot)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::Snapshots" do
      ec2.snapshots.all.reload.should be_a(Fog::AWS::EC2::Snapshots)
    end

  end

end
