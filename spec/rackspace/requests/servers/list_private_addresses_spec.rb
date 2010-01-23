require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_private_addresses' do
  describe 'success' do

    before(:each) do
      # flavor 1 = 256, image 3 = gentoo 2008.0
      @server_id = Rackspace[:servers].create_server(1, 3, 'name').body['server']['id']
    end

    after(:each) do
      eventually(128) do
        Rackspace[:servers].delete_server(@server_id)
      end
    end

    it "should return proper attributes" do
      actual = Rackspace[:servers].list_private_addresses(@server_id).body
      actual['private'].should be_an(Array)
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the server does not exist" do
      lambda {
        Rackspace[:servers].list_private_addresses(0)
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end