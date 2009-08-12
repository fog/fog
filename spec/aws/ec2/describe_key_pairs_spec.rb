require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_key_pairs' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @ec2.create_key_pair('key_name')
  end

  after(:all) do
    @ec2.delete_key_pair('key_name')
  end

  it "should return proper attributes with no params" do
    actual = @ec2.describe_key_pairs
    actual.body['keySet'].should be_an(Array)
    actual.body['requestId'].should be_a(String)
    key_pair = actual.body['keySet'].select {|key| key['keyName'] == 'key_name' }.first
    key_pair['keyFingerprint'].should be_a(String)
    key_pair['keyName'].should be_a(String)
  end
  
  it "should return proper attributes with params" do
    actual = @ec2.describe_key_pairs(['key_name'])
    actual.body['keySet'].should be_an(Array)
    actual.body['requestId'].should be_a(String)
    key_pair = actual.body['keySet'].select {|key| key['keyName'] == 'key_name' }.first
    key_pair['keyFingerprint'].should be_a(String)
    key_pair['keyName'].should be_a(String)
  end

end
