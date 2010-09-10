require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.delete_object' do
  describe 'success' do

    before(:each) do
      Rackspace[:storage].put_container('container_name')
      Rackspace[:storage].put_object('container_name', 'object_name', lorem_file)
    end

    after(:each) do
      Rackspace[:storage].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:storage].delete_object('container_name', 'object_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      lambda do
        Rackspace[:storage].delete_object('container_name', 'object_name')
      end.should raise_error(Fog::Rackspace::Storage::NotFound)
    end

    it "should raise a NotFound error if the object does not exist" do
      Rackspace[:storage].put_container('container_name')
      lambda do
        Rackspace[:storage].delete_object('container_name', 'object_name')
      end.should raise_error(Fog::Rackspace::Storage::NotFound)
      Rackspace[:storage].delete_container('container_name')
    end

  end
end
