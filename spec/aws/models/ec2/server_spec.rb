require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Server' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      server = ec2.servers.new({
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
      server.ami_launch_index.should == 'ami_launch_index'
      server.dns_name.should == 'dns_name'
      server.group_id.should == 'group_id'
      server.image_id.should == 'image_id'
      server.id.should == 'instance_id'
      server.type.should == 'instance_type'
      server.kernel_id.should == 'kernel_id'
      server.key_name.should == 'key_name'
      server.created_at.should == 'launch_time'
      server.product_codes.should == 'product_codes'
      server.private_dns_name.should == 'private_dns_name'
      server.ramdisk_id.should == 'ramdisk_id'
    end

  end

  describe "#addresses" do

    it "should return a Fog::AWS::EC2::Addresses" do
      server = ec2.servers.create(:image_id => GENTOO_AMI)
      server.addresses.should be_a(Fog::AWS::EC2::Addresses)
      server.destroy
    end

  end

  describe "#destroy" do

    it "should return true if the server is deleted" do
      server = ec2.servers.create(:image_id => GENTOO_AMI)
      server.destroy.should be_true
    end

  end

  describe "#state" do
    it "should remap values out of hash" do
      server = Fog::AWS::EC2::Server.new({
        'instanceState' => { 'name' => 'instance_state' },
      })
      server.state.should == 'instance_state'
    end
  end

  describe "#collection" do

    it "should return a Fog::AWS::EC2::Servers" do
      ec2.servers.new.collection.should be_a(Fog::AWS::EC2::Servers)
    end

    it "should be the servers the server is related to" do
      servers = ec2.servers
      servers.new.collection.should == servers
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
      server = Fog::AWS::EC2::Server.new({
        'monitoring' => { 'state' => true }
      })
      server.monitoring.should == true
    end
  end

  describe "#placement=" do

    it "should remap values into availability_zone" do
      server = Fog::AWS::EC2::Server.new({
        'placement' => { 'availabilityZone' => 'availability_zone' }
      })
      server.availability_zone.should == 'availability_zone'
    end

  end

  describe "#reload" do

    before(:each) do
      @server = ec2.servers.create(:image_id => GENTOO_AMI)
      @reloaded = @server.reload
    end

    after(:each) do
      @server.destroy
    end

    it "should return a Fog::AWS::EC2::Server" do
      @reloaded.should be_a(Fog::AWS::EC2::Server)
    end

    it "should reset attributes to remote state" do
      @server.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @server = ec2.servers.new(:image_id => GENTOO_AMI)
    end

    it "should return true when it succeeds" do
      @server.save.should be_true
      @server.destroy
    end

    it "should not exist in servers before save" do
      ec2.servers.get(@server.id).should be_nil
    end

    it "should exist in buckets after save" do
      @server.save
      ec2.servers.get(@server.id).should_not be_nil
      @server.destroy
    end

  end

  describe "#volumes" do

    it "should return a Fog::AWS::EC2::Volumes" do
      server = ec2.servers.create(:image_id => GENTOO_AMI)
      server.volumes.should be_a(Fog::AWS::EC2::Volumes)
      server.destroy
    end

  end

end
