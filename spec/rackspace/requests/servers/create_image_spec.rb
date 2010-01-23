require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.create_image' do
  describe 'success' do

    before(:each) do
      # flavor 1 = 256, image 3 = gentoo 2008.0
      @server_id = Rackspace[:servers].create_server(1, 3, 'name').body['server']['id']
    end

    after(:each) do
      eventually(128) do
        Rackspace[:servers].delete_server(@server_id)
      end
      Rackspace[:servers].delete_image(@image_id)
    end

    it "should return proper attributes" do
      actual = Rackspace[:servers].create_image(@server_id).body['image']
      @image_id = actual['id']
      actual['id'].should be_an(Integer)
      actual['serverId'].should be_an(Integer)
    end

  end
end