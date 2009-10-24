require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::KeyPair' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      key_pair = Fog::AWS::EC2::KeyPair.new(
        'keyFingerprint'  => 'fingerprint',
        'keyMaterial'     => 'material',
        'keyName'         => 'name'
      )
      key_pair.fingerprint.should == 'fingerprint'
      key_pair.material.should == 'material'
      key_pair.name.should == 'name'
    end

  end

  describe "#collection" do

    it "should return a Fog::AWS::EC2::KeyPairs" do
      ec2.key_pairs.new.collection.should be_a(Fog::AWS::EC2::KeyPairs)
    end

    it "should be the key_pairs the keypair is related to" do
      key_pairs = ec2.key_pairs
      key_pairs.new.collection.should == key_pairs
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
      ec2.key_pairs.get(@key_pair.name).should be_nil
    end

    it "should exist in buckets after save" do
      @key_pair.save
      ec2.key_pairs.get(@key_pair.name).should_not be_nil
      @key_pair.destroy
    end

  end

end
