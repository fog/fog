require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.delete_image' do
  describe 'success' do

    before(:each) do
      # flavor 1 = 256, image 3 = gentoo 2008.0
      @server_id = servers.create_server(1, 3).body['server']['id']
      @image_id = servers.create_image(@server_id)
    end

    it "should return proper attributes" do
      eventually(128) do
        servers.delete_server(@server_id)
      end
    end

    it "should return proper attributes" do
      servers.delete_image(@image_id)
    end

  end
end