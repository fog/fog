require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_volume' do

  after(:all) do
    ec2.delete_volume(@volume_id)
  end

  it "should return proper attributes" do
    actual = ec2.create_volume('us-east-1a', 1)
    actual.body[:availability_zone].should be_a(String)
    actual.body[:create_time].should be_a(Time)
    actual.body[:request_id].should be_a(String)
    actual.body[:size].should == 1
    actual.body[:snapshot_id].should == ''
    actual.body[:status].should be_a(String)
    actual.body[:volume_id].should be_a(String)
    @volume_id = actual.body[:volume_id]
  end

end
