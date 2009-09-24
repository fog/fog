require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Volumes' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::Volumes" do
      ec2.volumes.all.should be_a(Fog::AWS::EC2::Volumes)
    end

    it "should include persisted volumes" do
      volume = ec2.volumes.create
      ec2.volumes.get(volume.volume_id).should_not be_nil
      volume.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @volume = ec2.volumes.create
    end

    after(:each) do
      @volume.destroy
    end

    it "should return a Fog::AWS::EC2::Volume" do
      @volume.should be_a(Fog::AWS::EC2::Volume)
    end

    it "should exist on ec2" do
      ec2.volumes.get(@volume.volume_id).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::Volume if a matching volume exists" do
      volume = ec2.volumes.create
      get = ec2.volumes.get(volume.volume_id)
      volume.attributes.should == get.attributes
      volume.destroy
    end

    it "should return nil if no matching address exists" do
      ec2.volumes.get('vol-00000000').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::Volume" do
      ec2.volumes.new.should be_a(Fog::AWS::EC2::Volume)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::Volumes" do
      ec2.volumes.all.reload.should be_a(Fog::AWS::EC2::Volumes)
    end

  end

end
