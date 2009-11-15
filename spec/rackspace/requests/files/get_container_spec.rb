require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.get_container' do
  describe 'success' do

    before(:each) do
      files.put_container('container_name')
      files.put_object('container_name', 'object_name', lorem_file)
    end
    
    after(:each) do
      files.delete_object('container_name', 'object_name')
      files.delete_container('container_name')
    end

    it "should return proper attributes" do
      actual = files.get_container('container_name').body
      actual.first['bytes'].should be_an(Integer)
      actual.first['content_type'].should be_a(String)
      actual.first['hash'].should be_a(String)
      actual.first['last_modified'].should be_a(String)
      actual.first['name'].should be_a(String)
    end

  end
  describe 'failure' do

    it "should not raise an if the container does not exist" do
      files.get_container('container_name')
    end

  end
end
