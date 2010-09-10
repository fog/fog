require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.head_containers' do
  describe 'success' do

    before(:each) do
      Rackspace[:storage].put_container('container_name')
    end

    after(:each) do
      Rackspace[:storage].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:storage].head_containers
    end

  end
end
