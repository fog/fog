require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.put_container' do
  describe 'success' do

    after(:each) do
      Rackspace[:files].delete_container('container_name')
    end

    it "should return proper attributes" do
      Rackspace[:files].put_container('container_name')
    end

  end
end
