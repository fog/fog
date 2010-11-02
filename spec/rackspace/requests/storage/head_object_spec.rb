require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.head_object' do
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
      Rackspace[:storage].head_object('container_name', 'object_name')
    end

  end
end
