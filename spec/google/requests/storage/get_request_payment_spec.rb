require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.get_request_payment' do
  describe 'success' do

    before(:each) do
      Google[:storage].put_bucket('foggetrequestpayment')
    end

    after(:each) do
      Google[:storage].delete_bucket('foggetrequestpayment')
    end

    it 'should return proper attributes' do
      actual = Google[:storage].get_request_payment('foggetrequestpayment')
      actual.status.should == 200
      actual.body['Payer'].should == 'BucketOwner'
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        Google[:storage].get_request_payment('fognotabucket')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
