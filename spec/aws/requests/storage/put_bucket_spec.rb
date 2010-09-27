require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.put_bucket' do
  describe 'success' do

    before(:each) do
      @response = AWS[:storage].put_bucket('fogputbucket')
    end

    after(:each) do
      AWS[:storage].delete_bucket('fogputbucket')
    end

    it 'should not raise an error if the bucket already exists' do
      AWS[:storage].put_bucket('fogputbucket')
    end

  end
end
