require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.put_request_payment' do
  describe 'success' do

    before(:each) do
      AWS[:s3].put_bucket('fogputrequestpayment')
    end

    after(:each) do
      AWS[:s3].delete_bucket('fogputrequestpayment')
    end

    it 'should return proper attributes' do
      actual = AWS[:s3].put_request_payment('fogputrequestpayment', 'Requester')
      actual.status.should == 200
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if bucket does not exist' do
      lambda {
        AWS[:s3].put_request_payment('fognotabucket', 'Requester')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
