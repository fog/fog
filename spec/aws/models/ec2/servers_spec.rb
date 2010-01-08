require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Servers' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::Servers" do
      ec2.servers.all.should be_a(Fog::AWS::EC2::Servers)
    end

    it "should include persisted servers" do
      server = ec2.servers.create(:image_id => GENTOO_AMI)
      ec2.servers.get(server.id).should_not be_nil
      server.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @server = ec2.servers.create(:image_id => GENTOO_AMI)
    end

    after(:each) do
      @server.destroy
    end

    it "should return a Fog::AWS::EC2::Server" do
      @server.should be_a(Fog::AWS::EC2::Server)
    end

    it "should exist on ec2" do
      ec2.servers.get(@server.id).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::Server if a matching server exists" do
      server = ec2.servers.create(:image_id => GENTOO_AMI)
      get = ec2.servers.get(server.id)
      server.attributes.should == get.attributes
      server.destroy
    end

    it "should return nil if no matching server exists" do
      ec2.servers.get('i-00000000').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::Server" do
      ec2.servers.new(:image_id => GENTOO_AMI).should be_a(Fog::AWS::EC2::Server)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::Servers" do
      ec2.servers.all.reload.should be_a(Fog::AWS::EC2::Servers)
    end

  end

end
