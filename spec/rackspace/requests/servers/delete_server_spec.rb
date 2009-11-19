require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.delete_server' do
  describe 'success' do

    before(:each) do
      # flavor 1 = 256, image 3 = gentoo 2008.0
      @server_id = servers.create_server(1, 3, 'name').body['server']['id']
    end

    it "should return proper attributes" do
      eventually(128) do
        servers.delete_server(@server_id)
      end
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the server does not exist" do
      lambda {
        servers.delete_server(0)
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end