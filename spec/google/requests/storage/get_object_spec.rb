require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.get_object' do
  describe 'success' do

    before(:each) do
      Google[:storage].put_bucket('foggetobject')
      Google[:storage].put_object('foggetobject', 'fog_get_object', lorem_file)
    end

    after(:each) do
      Google[:storage].delete_object('foggetobject', 'fog_get_object')
      Google[:storage].delete_bucket('foggetobject')
    end

    it 'should return proper attributes' do
      actual = Google[:storage].get_object('foggetobject', 'fog_get_object')
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
      Google[:storage].get_object('foggetobject', 'fog_get_object') do |chunk|
        data << chunk
      end
      data.should == lorem_file.read
    end

    it 'should return a signed expiring url' do
      url = Google[:storage].get_object_url('foggetobject', 'fog_get_object', Time.now + 60 * 10)
      unless Fog.mocking?
        open(url).read.should == lorem_file.read
      end
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        Google[:storage].get_object('fognotabucket', 'fog_get_object')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a NotFound error if the object does not exist' do
      lambda {
        Google[:storage].get_object('foggetobject', 'fog_not_an_object')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
