require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.put_bucket' do
  describe 'success' do

    before(:each) do
      @response = AWS[:s3].put_bucket('fogputbucket')
    end

    after(:each) do
      AWS[:s3].delete_bucket('fogputbucket')
    end

    it 'should not raise an error if the bucket already exists' do
      AWS[:s3].put_bucket('fogputbucket')
    end

  end
end
