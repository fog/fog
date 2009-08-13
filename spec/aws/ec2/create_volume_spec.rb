require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_volume' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
  end

  after(:all) do
    @ec2.delete_volume(@volume_id)
  end

  it "should return proper attributes" do
    actual = @ec2.create_volume('us-east-1a', 1)
    actual.body['availabilityZone'].should be_a(String)
    actual.body['createTime'].should be_a(Time)
    actual.body['requestId'].should be_a(String)
    actual.body['size'].should == 1
    actual.body['snapshotId'].should == ''
    actual.body['status'].should be_a(String)
    actual.body['volumeId'].should be_a(String)
    @volume_id = actual.body['volumeId']
  end

end
