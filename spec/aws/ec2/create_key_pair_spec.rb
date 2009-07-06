require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_key_pair' do

  after(:all) do
    ec2.delete_key_pair('fog_key_pair')
  end

  it "should return proper attributes" do
    actual = ec2.create_key_pair('fog_key_pair')
    actual.body[:key_fingerprint].should be_a(String)
    actual.body[:key_material].should be_a(String)
    actual.body[:key_name].should be_a(String)
    actual.body[:request_id].should be_a(String)
  end

end
