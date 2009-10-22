require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Instances' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::Instances" do
      ec2.instances.all.should be_a(Fog::AWS::EC2::Instances)
    end

    it "should include persisted instances" do
      instance = ec2.instances.create(:image_id => GENTOO_AMI)
      ec2.instances.get(instance.instance_id).should_not be_nil
      instance.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @instance = ec2.instances.create(:image_id => GENTOO_AMI)
    end

    after(:each) do
      @instance.destroy
    end

    it "should return a Fog::AWS::EC2::Instance" do
      @instance.should be_a(Fog::AWS::EC2::Instance)
    end

    it "should exist on ec2" do
      ec2.instances.get(@instance.instance_id).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::Instance if a matching instance exists" do
      instance = ec2.instances.create(:image_id => GENTOO_AMI)
      get = ec2.instances.get(instance.instance_id)
      instance.attributes.should == get.attributes
      instance.destroy
    end

    it "should return nil if no matching instance exists" do
      ec2.instances.get('i-00000000').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::Instance" do
      ec2.instances.new(:image_id => GENTOO_AMI).should be_a(Fog::AWS::EC2::Instance)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::Instances" do
      ec2.instances.all.reload.should be_a(Fog::AWS::EC2::Instances)
    end

  end

end
