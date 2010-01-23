require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::SecurityGroups' do

  describe "#all" do

    it "should return a Fog::AWS::EC2::SecurityGroups" do
      AWS[:ec2].security_groups.all.should be_a(Fog::AWS::EC2::SecurityGroups)
    end

    it "should include persisted security_groups" do
      security_group = AWS[:ec2].security_groups.create(:description => 'groupdescription', :name => 'keyname')
      AWS[:ec2].security_groups.get(security_group.name).should_not be_nil
      security_group.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @security_group = AWS[:ec2].security_groups.create(:description => 'groupdescription', :name => 'keyname')
    end

    after(:each) do
      @security_group.destroy
    end

    it "should return a Fog::AWS::EC2::SecurityGroup" do
      @security_group.should be_a(Fog::AWS::EC2::SecurityGroup)
    end

    it "should exist on ec2" do
      AWS[:ec2].security_groups.get(@security_group.name).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::SecurityGroup if a matching security_group exists" do
      security_group = AWS[:ec2].security_groups.create(:description => 'groupdescription', :name => 'keyname')
      get = AWS[:ec2].security_groups.get(security_group.name)
      security_group.attributes[:fingerprint].should == get.attributes[:fingerprint]
      security_group.attributes[:name].should == get.attributes[:name]
      security_group.destroy
    end

    it "should return nil if no matching security_group exists" do
      AWS[:ec2].security_groups.get('notasecuritygroupname').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::SecurityGroup" do
      AWS[:ec2].security_groups.new(:description => 'groupdescription', :name => 'keyname').should be_a(Fog::AWS::EC2::SecurityGroup)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::SecurityGroups" do
      AWS[:ec2].security_groups.all.reload.should be_a(Fog::AWS::EC2::SecurityGroups)
    end

  end

end
