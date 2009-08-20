require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.delete_key_pair' do
  describe 'success' do

    before(:all) do
      ec2.create_key_pair('fog_key_pair')
    end

    it "should return proper attributes" do
      actual = ec2.delete_key_pair('fog_key_pair')
      actual.body['requestId'].should be_a(String)
      [false, true].should include(actual.body['return'])
    end

    it "should not raise an error if the key pair does not exist" do
      ec2.delete_key_pair('not_a_key_pair')
    end

  end
end
