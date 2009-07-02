require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_volumes' do

  before(:all) do
    @volume_id = ec2.create_volume('us-east-1a', 1).body[:volume_id]
  end

  after(:all) do
    ec2.delete_volume(@volume_id)
  end

  it "should return proper attributes with no params" do
    actual = ec2.describe_volumes
    actual.body[:request_id].should be_a(String)
    volume = actual.body[:volume_set].select {|volume| volume[:volume_id] == @volume_id}.first
    volume[:availability_zone].should be_a(String)
    volume[:create_time].should be_a(Time)
    volume[:size].should == 1
    volume[:snapshot_id].should == ''
    volume[:status].should be_a(String) 
    volume[:volume_id].should == @volume_id
    volume[:attachment_set].should == []
  end

  it "should return proper attributes for specific volume" do
    actual = ec2.describe_volumes(@volume_id)
    actual.body[:request_id].should be_a(String)
    volume = actual.body[:volume_set].select {|volume| volume[:volume_id] == @volume_id}.first
    volume[:availability_zone].should be_a(String)
    volume[:create_time].should be_a(Time)
    volume[:size].should == 1
    volume[:snapshot_id].should == ''
    volume[:status].should be_a(String)
    volume[:volume_id].should == @volume_id
    volume[:attachment_set].should == []
  end

end
