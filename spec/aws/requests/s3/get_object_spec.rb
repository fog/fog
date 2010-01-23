require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.get_object' do
  describe 'success' do

    before(:each) do
      AWS[:s3].put_bucket('foggetobject')
      AWS[:s3].put_object('foggetobject', 'fog_get_object', lorem_file)
    end

    after(:each) do
      AWS[:s3].delete_object('foggetobject', 'fog_get_object')
      AWS[:s3].delete_bucket('foggetobject')
    end

    it 'should return proper attributes' do
      actual = AWS[:s3].get_object('foggetobject', 'fog_get_object')
      actual.status.should == 200
      data = lorem_file.read
      actual.body.should == data
      actual.headers['Content-Length'].should == data.length.to_s
      actual.headers['Content-Type'].should be_a(String)
      actual.headers['ETag'].should be_a(String)
      actual.headers['Last-Modified'].should be_a(String)
    end

    it 'should return chunks with optional block' do
      data = ''
      AWS[:s3].get_object('foggetobject', 'fog_get_object') do |chunk|
        data << chunk
      end
      data.should == lorem_file.read
    end

    it 'should return a signed expiring url' do
      url = AWS[:s3].get_object_url('foggetobject', 'fog_get_object', Time.now + 60 * 10)
      unless Fog.mocking?
        open(url).read.should == lorem_file.read
      end
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        AWS[:s3].get_object('fognotabucket', 'fog_get_object')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a NotFound error if the object does not exist' do
      lambda {
        AWS[:s3].get_object('foggetobject', 'fog_not_an_object')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
