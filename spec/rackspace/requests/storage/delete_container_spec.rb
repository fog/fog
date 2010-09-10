require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.delete_container' do
  describe 'success' do

    before(:each) do
      Rackspace[:storage].put_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:storage].delete_container('container_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      lambda do
        Rackspace[:storage].delete_container('container_name')
      end.should raise_error(Fog::Rackspace::Storage::NotFound)
    end

  end
end
