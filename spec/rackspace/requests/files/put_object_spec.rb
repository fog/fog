require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.put_object' do
  describe 'success' do

    before(:each) do
      files.put_container('container_name')
    end
    
    after(:each) do
      files.delete_object('object_name')
      files.delete_container('container_name')
    end

    it "should return proper attributes" do
      files.put_object('container_name', 'object_name', lorem_file)
    end

  end
end
