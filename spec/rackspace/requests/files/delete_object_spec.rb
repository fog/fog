require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.delete_object' do
  describe 'success' do

    before(:each) do
      Rackspace[:files].put_container('container_name')
      Rackspace[:files].put_object('container_name', 'object_name', lorem_file)
    end
    
    after(:each) do
      Rackspace[:files].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:files].delete_object('container_name', 'object_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      lambda do
        Rackspace[:files].delete_object('container_name', 'object_name')
      end.should raise_error(Excon::Errors::NotFound)
    end

    it "should raise a NotFound error if the object does not exist" do
      Rackspace[:files].put_container('container_name')
      lambda do
        Rackspace[:files].delete_object('container_name', 'object_name')
      end.should raise_error(Excon::Errors::NotFound)
      Rackspace[:files].delete_container('container_name')
    end

  end
end
