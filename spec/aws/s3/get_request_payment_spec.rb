require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.get_request_payment' do

  before(:all) do
    @s3 = Fog::AWS::S3.gen
    @s3.put_bucket('foggetrequestpayment')
  end

  after(:all) do
    @s3.delete_bucket('foggetrequestpayment')
  end

  it 'should return proper attributes' do
    actual = @s3.get_request_payment('foggetrequestpayment')
    actual.status.should == 200
    actual.body['Payer'].should == 'BucketOwner'
  end

  it 'should raise a NotFound error if the bucket does not exist' do
    lambda {
      @s3.get_request_payment('fognotabucket')
    }.should raise_error(Fog::Errors::NotFound)
  end

end