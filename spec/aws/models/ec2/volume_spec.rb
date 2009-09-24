require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Volume' do

  describe "#initialize" do

    it "should remap attributes from parser" # do
    #       volume = Fog::AWS::EC2::Volume.new(
    #         'instanceId'  => 'i-00000000',
    #         'publicIp'    => '0.0.0.0'
    #       )
    #       address.instance_id.should == 'i-00000000'
    #       address.public_ip.should == '0.0.0.0'
    #     end

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
