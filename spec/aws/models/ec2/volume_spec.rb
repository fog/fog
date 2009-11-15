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

  describe "#collection" do

    it "should return a Fog::AWS::EC2::Volumes" do
      ec2.volumes.new.collection.should be_a(Fog::AWS::EC2::Volumes)
    end

    it "should be the volumes the volume is related to" do
      volumes = ec2.volumes
      volumes.new.collection.should == volumes
    end

  end

  describe "#destroy" do

    it "should return true if the volume is deleted" do
      volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
      volume.destroy.should be_true
    end

  end

  describe "#instance=" do
    before(:each) do
      @instance = ec2.instances.create(:image_id => GENTOO_AMI)
      @volume = ec2.volumes.new(:availability_zone => @instance.availability_zone, :size => 1, :device => 'dev/sdz1')
      while @instance.instance_state == 'pending'
        @instance.reload
      end
      while @volume.status == 'creating'
        @volume.reload
      end
    end

    after(:each) do
      @instance.destroy
      if @volume.volume_id
        @volume.instance = nil
        @volume.destroy
      end
    end

    it "should not attach to instance if the volume has not been saved" do
      @volume.instance = @instance
      @volume.instance_id.should_not == @instance.instance_id
    end

    it "should change the availability_zone if the volume has not been saved" do
      @volume.instance = @instance
      @volume.availability_zone.should == @instance.availability_zone
    end

    it "should attach to instance when the volume is saved" do
      @volume.instance = @instance
      @volume.save.should be_true
      @volume.instance_id.should == @instance.instance_id
    end

    it "should attach to instance to an already saved volume" do
      @volume.save.should be_true
      @volume.instance = @instance
      @volume.instance_id.should == @instance.instance_id
    end

    it "should not change the availability_zone if the volume has been saved" do
      @volume.save.should be_true
      @volume.instance = @instance
      @volume.availability_zone.should == @instance.availability_zone
    end
  end

  describe "#reload" do

    before(:each) do
      @volume = ec2.volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
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
      @volume = ec2.volumes.new(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
    end

    it "should return true when it succeeds" do
      @volume.save.should be_true
      @volume.destroy
    end

    it "should not exist in volumes before save" do
      ec2.volumes.get(@volume.volume_id).should be_nil
    end

    it "should exist in buckets after save" do
      @volume.save
      ec2.volumes.get(@volume.volume_id).should_not be_nil
      @volume.destroy
    end

  end

end
