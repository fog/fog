require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.head_containers' do
  describe 'success' do

    before(:each) do
      files.put_container('container_name')
    end

    after(:each) do
      files.delete_container('container_name')
    end

    it "should return proper attributes" do
      files.head_containers
    end

  end
end
