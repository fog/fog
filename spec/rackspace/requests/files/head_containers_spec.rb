require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.head_containers' do
  describe 'success' do

    before(:each) do
      Rackspace[:files].put_container('container_name')
    end

    after(:each) do
      Rackspace[:files].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:files].head_containers
    end

  end
end
