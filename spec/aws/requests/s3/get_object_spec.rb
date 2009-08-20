require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.get_object' do
  describe 'success' do

    before(:each) do
      s3.put_bucket('foggetobject')
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      s3.put_object('foggetobject', 'fog_get_object', file)
    end

    after(:each) do
      s3.delete_object('foggetobject', 'fog_get_object')
      s3.delete_bucket('foggetobject')
    end

    it 'should return proper attributes' do
      actual = s3.get_object('foggetobject', 'fog_get_object')
      actual.status.should == 200
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      data = file.read
      actual.body.should == data
      actual.headers['Content-Length'].should == data.length.to_s
      actual.headers['ETag'].should be_a(String)
      actual.headers['Last-Modified'].should be_a(String)
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        s3.get_object('fognotabucket', 'fog_get_object')
      }.should raise_error(Fog::Errors::NotFound)
    end

    it 'should raise a NotFound error if the object does not exist' do
      lambda {
        s3.get_object('foggetobject', 'fog_not_an_object')
      }.should raise_error(Fog::Errors::NotFound)
    end

  end
end
