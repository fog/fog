require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Instance' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      instance = Fog::AWS::EC2::Instance.new({
        'amiLaunchIndex'    => 'ami_launch_index',
        'dnsName'           => 'dns_name',
        'groupId'           => 'group_id',
        'imageId'           => 'image_id',
        'instanceId'        => 'instance_id',
        'instanceType'      => 'instance_type',
        'kernelId'          => 'kernel_id',
        'keyName'           => 'key_name',
        'launchTime'        => 'launch_time',
        'productCodes'      => 'product_codes',
        'privateDnsName'    => 'private_dns_name',
        'ramdiskId'         => 'ramdisk_id'
      })
      instance.ami_launch_index.should == 'ami_launch_index'
      instance.dns_name.should == 'dns_name'
      instance.group_id.should == 'group_id'
      instance.image_id.should == 'image_id'
      instance.instance_id.should == 'instance_id'
      instance.instance_type.should == 'instance_type'
      instance.kernel_id.should == 'kernel_id'
      instance.key_name.should == 'key_name'
      instance.launch_time.should == 'launch_time'
      instance.product_codes.should == 'product_codes'
      instance.private_dns_name.should == 'private_dns_name'
      instance.ramdisk_id.should == 'ramdisk_id'
    end

  end

  describe "#addresses" do

    it "should return a Fog::AWS::EC2::Addresses" do
      instance = ec2.instances.new
      instance.addresses.should be_a(Fog::AWS::EC2::Addresses)
    end

  end

  describe "#destroy" do

    it "should return true if the instance is deleted" do
      instance = ec2.instances.create(:image_id => GENTOO_AMI)
      instance.destroy.should be_true
    end

  end

  describe "#instance_state" do
    it "should remap values out of hash" do
      instance = Fog::AWS::EC2::Instance.new({
        'instanceState' => { 'name' => 'instance_state' },
      })
      instance.instance_state.should == 'instance_state'
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
    it "should remap values out of hash" do
      instance = Fog::AWS::EC2::Instance.new({
        'monitoring' => { 'state' => true }
      })
      instance.monitoring.should == true
    end
  end

  describe "#placement=" do

    it "should remap values into availability_zone" do
      instance = Fog::AWS::EC2::Instance.new({
        'placement' => { 'availabilityZone' => 'availability_zone' }
      })
      instance.availability_zone.should == 'availability_zone'
    end

  end

  describe "#reload" do

    before(:each) do
      @instance = ec2.instances.create(:image_id => GENTOO_AMI)
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

    it "should return a Fog::AWS::EC2::Volumes" do
      instance = ec2.instances.new
      instance.volumes.should be_a(Fog::AWS::EC2::Volumes)
    end

  end

end
