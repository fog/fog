require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.delete_object' do
  describe 'success' do

    before(:each) do
      files.put_container('container_name')
      files.put_object('container_name', 'object_name', lorem_file)
    end
    
    after(:each) do
      files.delete_container('container_name')
    end

    it "should return proper attributes" do
      files.delete_object('container_name', 'object_name')
    end

  end
end
