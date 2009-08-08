require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.put_request_payment' do

  before(:all) do
    @s3 = s3
    @s3.put_bucket('fogputrequestpayment')
  end

  after(:all) do
    @s3.delete_bucket('fogputrequestpayment')
  end

  it 'should return proper attributes' do
    actual = @s3.put_request_payment('fogputrequestpayment', 'Requester')
    actual.status.should == 200
  end

end