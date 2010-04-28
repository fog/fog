require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Snapshots' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      snapshot = AWS[:ec2].snapshots.new(
        'snapshotId'  => 'snap-00000000',
        'startTime'   => 'now',
        'volumeId'    => 'vol-00000000'
      )
      snapshot.id.should == 'snap-00000000'
      snapshot.created_at.should == 'now'
      snapshot.volume_id.should == 'vol-00000000'
    end

  end

  describe "#collection" do

    it "should return a Fog::AWS::EC2::Snapshots" do
      AWS[:ec2].snapshots.new.collection.should be_a(Fog::AWS::EC2::Snapshots)
    end

    it "should be the snapshots the snapshot is related to" do
      snapshots = AWS[:ec2].snapshots
      snapshots.new.collection.should == snapshots
    end

  end

  describe "#destroy" do

    it "should return true if the snapshot is deleted" do
      volume = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      snapshot = volume.snapshots.create
      snapshot.wait_for { ready? }
      snapshot.destroy.should be_true
      volume.destroy
    end

  end

  describe "#reload" do

    before(:each) do
      @volume   = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      @snapshot = @volume.snapshots.create
      @reloaded = @snapshot.reload
    end

    after(:each) do
      @snapshot.wait_for { ready? }
      @snapshot.destroy
      @volume.destroy
    end

    it "should return a Fog::AWS::EC2::Snapshot" do
      @reloaded.should be_a(Fog::AWS::EC2::Snapshot)
    end

    it "should reset attributes to remote state" do
      @snapshot.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @volume   = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      @volume.wait_for { ready? }
      @snapshot = @volume.snapshots.new
    end

    after(:each) do
      @volume.destroy
    end

    it "should return true when it succeeds" do
      @snapshot.save.should be_true
      @snapshot.wait_for { ready? }
      @snapshot.destroy
    end

    it "should not exist in snapshots before save" do
      AWS[:ec2].snapshots.get(@snapshot.id).should be_nil
    end

    it "should exist in snapshots after save" do
      @snapshot.save
      AWS[:ec2].snapshots.get(@snapshot.id).should_not be_nil
      @snapshot.wait_for { ready? }
      @snapshot.destroy
    end

  end

end
