require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_key_pair' do

  after(:all) do
    ec2.delete_key_pair('fog_key_pair')
  end

  it "should return proper attributes" do
    actual = ec2.create_key_pair('fog_key_pair')
    actual.body['keyFingerprint'].should be_a(String)
    actual.body['keyMaterial'].should be_a(String)
    actual.body['keyName'].should be_a(String)
    actual.body['requestId'].should be_a(String)
  end

end
