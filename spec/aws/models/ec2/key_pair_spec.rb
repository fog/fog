require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::KeyPair' do

  describe "#initialize" do

    it "should remap attributes from parser" #do
    #   address = Fog::AWS::EC2::KeyPair.new(
    #     'instanceId'  => 'i-00000000',
    #     'publicIp'    => '0.0.0.0'
    #   )
    #   address.instance_id.should == 'i-00000000'
    #   address.public_ip.should == '0.0.0.0'
    # end

  end

  describe "#key_pairs" do

    it "should return a Fog::AWS::EC2::KeyPairs" do
      ec2.key_pairs.new.key_pairs.should be_a(Fog::AWS::EC2::KeyPairs)
    end

    it "should be the key_pairs the keypair is related to" do
      key_pairs = ec2.key_pairs
      key_pairs.new.key_pairs.should == key_pairs
    end

  end

  describe "#destroy" do

    it "should return true if the key_pair is deleted" do
      address = ec2.key_pairs.create(:name => 'keyname')
      address.destroy.should be_true
    end

  end

  describe "#reload" do

    before(:each) do
      @key_pair = ec2.key_pairs.create(:name => 'keyname')
      @reloaded = @key_pair.reload
    end

    after(:each) do
      @key_pair.destroy
    end

    it "should return a Fog::AWS::EC2::KeyPair" do
      @reloaded.should be_a(Fog::AWS::EC2::KeyPair)
    end

    it "should reset attributes to remote state" do
      @key_pair.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @key_pair = ec2.key_pairs.new(:name => 'keyname')
    end

    it "should return true when it succeeds" do
      @key_pair.save.should be_true
      @key_pair.destroy
    end

    it "should not exist in key_pairs before save" do
      @key_pair.key_pairs.get(@key_pair.name).should be_nil
    end

    it "should exist in buckets after save" do
      @key_pair.save
      @key_pair.key_pairs.get(@key_pair.name).should_not be_nil
      @key_pair.destroy
    end

  end

end
