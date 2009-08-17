require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.put_request_payment' do

  before(:all) do
    @s3 = Fog::AWS::S3.gen
    @s3.put_bucket('fogputrequestpayment')
  end

  after(:all) do
    @s3.delete_bucket('fogputrequestpayment')
  end

  it 'should return proper attributes' do
    actual = @s3.put_request_payment('fogputrequestpayment', 'Requester')
    actual.status.should == 200
  end

  it 'should raise a NotFound error if bucket does not exist' do
    lambda {
      @s3.put_request_payment('fognotabucket', 'Requester')
    }.should raise_error(Fog::Errors::NotFound)
  end

end