require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.delete_bucket' do

  it 'should return stuff' do
    p s3.delete_bucket('fogputbucket')
  end

end