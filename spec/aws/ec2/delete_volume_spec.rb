require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_volume' do

  before(:all) do
    @volume_id = ec2.create_volume('us-east-1a', 1).body[:volume_id]
  end

  it "should return proper attributes" do
    actual = ec2.delete_volume(@volume_id)
    actual.body[:request_id].should be_a(String)
    actual.body[:return].should == true
  end

end
