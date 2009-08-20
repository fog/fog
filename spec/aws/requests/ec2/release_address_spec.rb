require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.release_address' do
  describe 'success' do

    before(:each) do
      @public_ip = ec2.allocate_address.body['publicIp']
    end

    it "should return proper attributes" do
      actual = ec2.release_address(@public_ip)
      actual.body['requestId'].should be_a(String)
      actual.body['return'].should == true
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if address does not exist" do
      lambda {
        ec2.release_address('127.0.0.1')
      }.should raise_error(Fog::Errors::BadRequest)
    end

  end
end
