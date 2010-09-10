require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.put_request_payment' do
  describe 'success' do

    before(:each) do
      AWS[:storage].put_bucket('fogputrequestpayment')
    end

    after(:each) do
      AWS[:storage].delete_bucket('fogputrequestpayment')
    end

    it 'should return proper attributes' do
      actual = AWS[:storage].put_request_payment('fogputrequestpayment', 'Requester')
      actual.status.should == 200
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if bucket does not exist' do
      lambda {
        AWS[:storage].put_request_payment('fognotabucket', 'Requester')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
