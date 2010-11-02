require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.delete_container' do
  describe 'success' do

    before(:each) do
      unless Fog.mocking?
        Rackspace[:storage].put_container('container_name')
      end
    end

    it "should return proper attributes" do
      pending if Fog.mocking?
      Rackspace[:storage].delete_container('container_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      pending if Fog.mocking?
      lambda do
        Rackspace[:storage].delete_container('container_name')
      end.should raise_error(Fog::Rackspace::Storage::NotFound)
    end

  end
end
