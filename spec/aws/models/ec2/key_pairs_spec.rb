require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::KeyPairs' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::KeyPairs" do
      AWS[:ec2].key_pairs.all.should be_a(Fog::AWS::EC2::KeyPairs)
    end

    it "should include persisted key_pairs" do
      key_pair = AWS[:ec2].key_pairs.create(:name => 'keyname')
      AWS[:ec2].key_pairs.get(key_pair.name).should_not be_nil
      key_pair.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @key_pair = AWS[:ec2].key_pairs.create(:name => 'keyname')
    end

    after(:each) do
      @key_pair.destroy
    end

    it "should return a Fog::AWS::EC2::KeyPair" do
      @key_pair.should be_a(Fog::AWS::EC2::KeyPair)
    end

    it "should exist on ec2" do
      AWS[:ec2].key_pairs.get(@key_pair.name).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::KeyPair if a matching key_pair exists" do
      key_pair = AWS[:ec2].key_pairs.create(:name => 'keyname')
      get = AWS[:ec2].key_pairs.get(key_pair.name)
      key_pair.attributes[:fingerprint].should == get.attributes[:fingerprint]
      key_pair.attributes[:name].should == get.attributes[:name]
      key_pair.destroy
    end

    it "should return nil if no matching key_pair exists" do
      AWS[:ec2].key_pairs.get('notakeyname').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::KeyPair" do
      AWS[:ec2].key_pairs.new(:name => 'keyname').should be_a(Fog::AWS::EC2::KeyPair)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::KeyPairs" do
      AWS[:ec2].key_pairs.all.reload.should be_a(Fog::AWS::EC2::KeyPairs)
    end

  end

end
