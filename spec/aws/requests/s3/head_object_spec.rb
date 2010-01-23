require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.head_object' do
  describe 'success' do

    before(:each) do
      AWS[:s3].put_bucket('fogheadobject')
      AWS[:s3].put_object('fogheadobject', 'fog_head_object', lorem_file)
    end

    after(:each) do
      AWS[:s3].delete_object('fogheadobject', 'fog_head_object')
      AWS[:s3].delete_bucket('fogheadobject')
    end

    it 'should return proper attributes' do
      actual = AWS[:s3].head_object('fogheadobject', 'fog_head_object')
      actual.status.should == 200
      data = lorem_file.read
      actual.headers['Content-Length'].should == data.length.to_s
      actual.headers['ETag'].should be_a(String)
      actual.headers['Last-Modified'].should be_a(String)
    end

  end
end
