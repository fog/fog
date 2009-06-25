require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.put_request_payment' do

  before(:all) do
    s3.put_bucket('fogputrequestpayment')
  end

  after(:all) do
    s3.delete_bucket('fogputrequestpayment')
  end

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.put_request_payment('fogputrequestpayment', 'Requester')
  end

end