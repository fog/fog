require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.delete_container' do
  describe 'success' do

    before(:each) do
      files.put_container('container_name')
    end

    it "should return proper attributes" do
      files.delete_container('container_name')
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the container does not exist" do
      lambda do
        files.delete_container('container_name')
      end.should raise_error(Excon::Errors::NotFound)
    end

  end
end
