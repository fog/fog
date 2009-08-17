require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.release_address' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @public_ip = @ec2.allocate_address.body['publicIp']
  end

  it "should return proper attributes" do
    actual = @ec2.release_address(@public_ip)
    actual.body['requestId'].should be_a(String)
    actual.body['return'].should == true
  end

  it "should raise a BadRequest error if address does not exist" do
    lambda {
      @ec2.release_address('0.0.0.0')
    }.should raise_error(Fog::Errors::BadRequest)
  end

end
