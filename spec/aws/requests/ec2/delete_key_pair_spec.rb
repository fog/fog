require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.delete_key_pair' do
  describe 'success' do

    before(:each) do
      ec2.create_key_pair('fog_key_name')
      @response = ec2.delete_key_pair('fog_key_name')
    end

    it "should return proper attributes" do
      @response.body['requestId'].should be_a(String)
      [false, true].should include(@response.body['return'])
    end

    it "should not raise an error if the key pair does not exist" do
      ec2.delete_key_pair('not_a_key_name')
    end

  end
end
