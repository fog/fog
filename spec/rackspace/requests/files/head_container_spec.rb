require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.head_container' do
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
      files.head_container('container_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      lambda do
        files.head_container('container_name')
      end.should raise_error(Excon::Errors::NotFound)
    end

  end
end
