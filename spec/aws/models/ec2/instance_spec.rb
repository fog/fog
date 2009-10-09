require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Instance' do

  describe "#initialize" do

    it "should remap attributes from parser" # do
    #       instance = Fog::AWS::EC2::Instance.new(
    #         'instanceId'  => 'i-00000000',
    #         'publicIp'    => '0.0.0.0'
    #       )
    #       instance.instance_id.should == 'i-00000000'
    #       instance.public_ip.should == '0.0.0.0'
    #     end

  end

  describe "#address" do
    it "should have tests"
  end

  describe "#destroy" do

    it "should return true if the instance is deleted" do
      instance = ec2.instances.create(:image_id => 'ami-5ee70037')
      instance.destroy.should be_true
    end

  end

  describe "#instances" do

    it "should return a Fog::AWS::EC2::Instances" do
      ec2.instances.new.instances.should be_a(Fog::AWS::EC2::Instances)
    end

    it "should be the instances the instance is related to" do
      instances = ec2.instances
      instances.new.instances.should == instances
    end

  end

  describe "#key_pair" do
    it "should have tests"
  end

  describe "#key_pair=" do
    it "should have tests"
  end

  describe "#monitoring=" do
    it "should have tests"
  end

  describe "#placement=" do
    it "should have tests"
  end

  describe "#reload" do

    before(:each) do
      @instance = ec2.instances.create(:image_id => 'ami-5ee70037')
      @reloaded = @instance.reload
    end

    after(:each) do
      @instance.destroy
    end

    it "should return a Fog::AWS::EC2::Instance" do
      @reloaded.should be_a(Fog::AWS::EC2::Instance)
    end

    it "should reset attributes to remote state" do
      @instance.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @instance = ec2.instances.new
    end

    it "should return true when it succeeds" do
      @instance.save.should be_true
      @instance.destroy
    end

    it "should not exist in instances before save" do
      @instance.instances.get(@instance.instance_id).should be_nil
    end

    it "should exist in buckets after save" do
      @instance.save
      @instance.instances.get(@instance.instance_id).should_not be_nil
      @instance.destroy
    end

  end

  describe "#volumes" do
    it "should have tests"
  end

end
