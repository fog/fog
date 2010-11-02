require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.get_container' do
  describe 'success' do

    before(:each) do
      unless Fog.mocking?
        Rackspace[:storage].put_container('container_name')
        Rackspace[:storage].put_object('container_name', 'object_name', lorem_file)
      end
    end

    after(:each) do
      Rackspace[:storage].delete_object('container_name', 'object_name')
      Rackspace[:storage].delete_container('container_name')
    end

    it "should return proper attributes" do
      pending if Fog.mocking?
      actual = Rackspace[:storage].get_container('container_name').body
      actual.first['bytes'].should be_an(Integer)
      actual.first['content_type'].should be_a(String)
      actual.first['hash'].should be_a(String)
      actual.first['last_modified'].should be_a(String)
      actual.first['name'].should be_a(String)
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      pending if Fog.mocking?
      lambda do
        Rackspace[:storage].get_container('container_name')
      end.should raise_error(Fog::Rackspace::Storage::NotFound)
    end

  end
end
