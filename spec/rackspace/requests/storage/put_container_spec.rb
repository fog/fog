require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Storage.put_container' do
  describe 'success' do

    after(:each) do
      Rackspace[:storage].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:storage].put_container('container_name')
    end

  end
end
