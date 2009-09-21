require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Addresses' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::Addresses" do
      s3.buckets.all.should be_a(Fog::AWS::S3::Addresses)
    end

    it "should include persisted addresses" do
      address = ec2.addresses.create
      ec2.addresses.get(address.public_ip).should_not be_nil
      address.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @address = ec2.addresses.create
    end

    after(:each) do
      @address.destroy
    end

    it "should return a Fog::AWS::EC2::Address" do
      @address.should be_a(Fog::AWS::EC2::Address)
    end

    it "should exist on ec2" do
      ec2.addresses.get(@public_ip).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::Address if a matching address exists" do
      address = ec2.addresses.create
      get = ec2.addresses.get(address.public_ip)
      address.attributes.should == get.attributes
      address.destroy
    end

    it "should return nil if no matching address exists" do
      ec2.addresses.get('0.0.0.0').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::Address" do
      s3.buckets.new.should be_a(Fog::AWS::EC2::Address)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::Addresses" do
      s3.buckets.all.should be_a(Fog::AWS::EC2::Addresses)
    end

  end

end
