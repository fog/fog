require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Snapshots' do

  before(:all) do
    @volume = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')
    @volume.wait_for { ready? }
  end

  after(:all) do
    @volume.destroy
  end

  after(:each) do
    if @snapshot && !@snapshot.new_record?
      @snapshot.wait_for { ready? }
      @snapshot.destroy
    end
  end

  describe "#all" do

    before(:each) do
      @snapshot = @volume.snapshots.create
    end

    it "should include persisted snapshots" do
      AWS[:ec2].snapshots.all.map {|snapshot| snapshot.id}.should include(@snapshot.id)
    end

    it "should limit snapshots by volume if present" do
      @other_volume = AWS[:ec2].volumes.create(:availability_zone => 'us-east-1a', :size => 1, :device => 'dev/sdz1')

      @volume.snapshots.map {|snapshot| snapshot.id}.should include(@snapshot.identity)
      @other_volume.snapshots.map {|snapshot| snapshot.id}.should_not include(@snapshot.identity)

      @other_volume.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @snapshot = @volume.snapshots.create
    end

    it "should exist on ec2" do
      AWS[:ec2].snapshots.get(@snapshot.id).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::EC2::Snapshot if a matching snapshot exists" do
      @snapshot = @volume.snapshots.create
      @snapshot.wait_for { ready? }
      get = AWS[:ec2].snapshots.get(@snapshot.id)
      @snapshot.attributes.should == get.attributes
    end

    it "should return nil if no matching address exists" do
      AWS[:ec2].snapshots.get('vol-00000000').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::EC2::Snapshot" do
      AWS[:ec2].snapshots.new.should be_a(Fog::AWS::EC2::Snapshot)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::EC2::Snapshots" do
      AWS[:ec2].snapshots.all.reload.should be_a(Fog::AWS::EC2::Snapshots)
    end

  end

end
