require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_volume' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @volume_id = @ec2.create_volume('us-east-1a', 1).body['volumeId']
  end

  it "should return proper attributes" do
    actual = @ec2.delete_volume(@volume_id)
    actual.body['requestId'].should be_a(String)
    actual.body['return'].should == true
  end

end
