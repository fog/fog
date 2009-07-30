require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.delete_bucket' do

  before(:all) do
    s3.put_bucket('fogdeletebucket')
  end

  it 'should return proper attributes' do
    actual = s3.delete_bucket('fogdeletebucket')
    actual.status.should == 204
  end

end
