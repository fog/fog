require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.put_bucket' do

  it 'should return stuff' do
    p s3.put_bucket('fogputbucket')
  end

end