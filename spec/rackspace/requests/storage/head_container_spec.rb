require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.head_container' do
  describe 'success' do

    before(:each) do
      Rackspace[:storage].put_container('container_name')
      Rackspace[:storage].put_object('container_name', 'object_name', lorem_file)
    end

    after(:each) do
      Rackspace[:storage].delete_object('container_name', 'object_name')
      Rackspace[:storage].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:storage].head_container('container_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      lambda do
        Rackspace[:storage].head_container('container_name')
      end.should raise_error(Fog::Rackspace::Storage::NotFound)
    end

  end
end
