require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.get_bucket' do

  before(:all) do
    s3.put_bucket('foggetbucket')
  end

  after(:all) do
    s3.delete_bucket('foggetbucket')
  end

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.get_bucket('fogputbucket')
  end

end
