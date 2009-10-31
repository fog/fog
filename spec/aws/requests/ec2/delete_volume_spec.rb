require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.create_volume' do
  describe 'success' do

    before(:each) do
      @volume_id = ec2.create_volume('us-east-1a', 1).body['volumeId']
    end

    it "should return proper attributes" do
      actual = ec2.delete_volume(@volume_id)
      actual.body['requestId'].should be_a(String)
      actual.body['return'].should == true
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if volume does not exist" do
      lambda {
        ec2.release_address('vol-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
