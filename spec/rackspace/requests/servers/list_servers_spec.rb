require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_servers' do
  describe 'success' do

    before(:each) do
      # flavor 1 = 256, image 3 = gentoo 2008.0
      @server_id = servers.create_server(1, 3, 'name').body['server']['id']
    end

    after(:each) do
      eventually(128) do
        servers.delete_server(@server_id)
      end
    end

    it "should return proper attributes" do
      actual = servers.list_servers.body['servers'].first
      actual['id'].should be_an(Integer)
      actual['name'].should be_a(String)
    end

  end
end
