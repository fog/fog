require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.put_bucket' do

  before(:all) do
    @s3 = s3
  end

  after(:all) do
    @s3.delete_bucket('fogputbucket')
  end

  it 'should return proper attributes' do
    actual = @s3.put_bucket('fogputbucket')
    actual.status.should == 200
  end

end
