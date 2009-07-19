require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_key_pairs' do

  before(:all) do
    ec2.create_key_pair('key_name')
  end

  after(:all) do
    ec2.delete_key_pair('key_name')
  end

  it "should return proper attributes with no params" do
    actual = ec2.describe_key_pairs
    actual.body[:key_set].should be_an(Array)
    actual.body[:request_id].should be_a(String)
    key = actual.body[:key_set].select {|key| key[:key_name] == 'key_name' }.first
    key[:key_name].should == 'key_name'
    key[:key_fingerprint].should be_a(String)
  end
  
  it "should return proper attributes with params" do
    actual = ec2.describe_key_pairs(['key_name'])
    actual.body[:key_set].should be_an(Array)
    actual.body[:request_id].should be_a(String)
    key = actual.body[:key_set].select {|key| key[:key_name] == 'key_name' }.first
    key[:key_name].should == 'key_name'
    key[:key_fingerprint].should be_a(String)
  end

end
