require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Snapshots' do

  describe "#initialize" do

    it "should remap attributes from parser" # do
    #       snapshot = Fog::AWS::EC2::Address.new(
    #         'instanceId'  => 'i-00000000',
    #         'publicIp'    => '0.0.0.0'
    #       )
    #       address.instance_id.should == 'i-00000000'
    #       address.public_ip.should == '0.0.0.0'
    #     end

  end

  describe "#snapshots" do

    it "should return a Fog::AWS::EC2::Snapshots" do
      ec2.snapshots.new.snapshots.should be_a(Fog::AWS::EC2::Snapshots)
    end

    it "should be the snapshots the snapshot is related to" do
      snapshots = ec2.snapshots
      snapshots.new.snapshots.should == snapshots
    end

  end

  describe "#destroy" do

    it "should return true if the snapshot is deleted" do
      volume = ec2.volumes.create
      snapshot = volume.snapshots.create
      snapshot.destroy.should be_true
      volume.destroy
    end

  end

  describe "#reload" do

    before(:each) do
      @volume   = ec2.volumes.create
      @snapshot = @volume.snapshots.create
      @reloaded = @snapshot.reload
    end

    after(:each) do
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
      @volume   = ec2.volumes.create
      @snapshot = @volume.snapshots.new
    end

    after(:each) do
      @volume.destroy
    end

    it "should return true when it succeeds" do
      @snapshot.save.should be_true
      @snapshot.destroy
    end

    it "should not exist in addresses before save" do
      @snapshot.snapshots.get(@snapshot.snapshot_id).should be_nil
    end

    it "should exist in buckets after save" do
      @snapshot.save
      @snapshot.snapshots.get(@snapshot.snapshot_id).should_not be_nil
      @snapshot.destroy
    end

  end

end
