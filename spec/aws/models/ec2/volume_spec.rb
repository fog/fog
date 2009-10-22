require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Volume' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      volume = Fog::AWS::EC2::Volume.new(
        'attachTime'    => 'now',
        'availabilityZone'  => 'us-east-1a',
        'createTime'        => 'recently',
        'instanceId'        => 'i-00000000',
        'snapshotId'        => 'snap-00000000',
        'volumeId'          => 'vol-00000000'
      )
      volume.attach_time.should == 'now'
      volume.availability_zone.should == 'us-east-1a'
      volume.create_time.should == 'recently'
      volume.instance_id.should == 'i-00000000'
      volume.snapshot_id.should == 'snap-00000000'
      volume.volume_id.should == 'vol-00000000'
    end

  end

  describe "#volumes" do

    it "should return a Fog::AWS::EC2::Volumes" do
      ec2.volumes.new.volumes.should be_a(Fog::AWS::EC2::Volumes)
    end

    it "should be the volumes the volume is related to" do
      volumes = ec2.volumes
      volumes.new.volumes.should == volumes
    end

  end

  describe "#destroy" do

    it "should return true if the volume is deleted" do
      volume = ec2.volumes.create
      volume.destroy.should be_true
    end

  end

  describe "#instance=" do
    before(:each) do
      @volume = ec2.volumes.new
      @instance = ec2.instances.create(:image_id => GENTOO_AMI)
    end

    after(:each) do
      if @volume.volume_id
        @volume.destroy
      end
      @instance.destroy
    end

    it "should not attach to instance if the address has not been saved" do
      @volume.instance = @instance
      @volume.instance_id.should_not == @instance.instance_id
    end

    it "should attach to instance when the address is saved" do
      @volume.instance = @instance
      @volume.save.should be_true
      @volume.instance_id.should == @instance.instance_id
    end

    it "should attach to instance to an already saved address" do
      @volume.save.should be_true
      @volume.instance = @instance
      @volume.instance_id.should == @instance.instance_id
    end
  end

  describe "#reload" do

    before(:each) do
      @volume = ec2.volumes.create
      @reloaded = @volume.reload
    end

    after(:each) do
      @volume.destroy
    end

    it "should return a Fog::AWS::EC2::Volume" do
      @reloaded.should be_a(Fog::AWS::EC2::Volume)
    end

    it "should reset attributes to remote state" do
      @volume.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @volume = ec2.volumes.new
    end

    it "should return true when it succeeds" do
      @volume.save.should be_true
      @volume.destroy
    end

    it "should not exist in addresses before save" do
      @volume.volumes.get(@volume.volume_id).should be_nil
    end

    it "should exist in buckets after save" do
      @volume.save
      @volume.volumes.get(@volume.volume_id).should_not be_nil
      @volume.destroy
    end

  end

end
