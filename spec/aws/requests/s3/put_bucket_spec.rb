require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.put_bucket' do

  after(:all) do
    s3.delete_bucket('fogputbucket')
  end

  it 'should return proper attributes' do
    actual = s3.put_bucket('fogputbucket')
    actual.status.should == 200
  end

  it 'should not raise an error if the bucket already exists' do
    s3.put_bucket('fogputbucket')
  end

end
