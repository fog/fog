require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_key_pairs' do
  describe 'success' do

    before(:each) do
      AWS[:ec2].create_key_pair('fog_key_name')
    end

    after(:each) do
      AWS[:ec2].delete_key_pair('fog_key_name')
    end

    it "should return proper attributes with no params" do
      actual = AWS[:ec2].describe_key_pairs
      actual.body['keySet'].should be_an(Array)
      actual.body['requestId'].should be_a(String)
      key_pair = actual.body['keySet'].select {|key| key['keyName'] == 'fog_key_name' }.first
      key_pair['keyFingerprint'].should be_a(String)
      key_pair['keyName'].should be_a(String)
    end
  
    it "should return proper attributes with params" do
      actual = AWS[:ec2].describe_key_pairs('fog_key_name')
      actual.body['keySet'].should be_an(Array)
      actual.body['requestId'].should be_a(String)
      key_pair = actual.body['keySet'].select {|key| key['keyName'] == 'fog_key_name' }.first
      key_pair['keyFingerprint'].should be_a(String)
      key_pair['keyName'].should be_a(String)
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if the key does not exist" do
      lambda {
        AWS[:ec2].describe_key_pairs('fog_not_a_key_name')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
