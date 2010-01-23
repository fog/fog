require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.get_server_details' do
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
      actual = Rackspace[:servers].get_server_details(@server_id).body['server']
      actual['addresses'].should be_a(Hash)
      actual['addresses']['private'].should be_an(Array)
      actual['addresses']['private'].first.should be_a(String)
      actual['addresses']['public'].should be_an(Array)
      actual['addresses']['public'].first.should be_a(String)
      actual['flavorId'].should be_an(Integer)
      actual['hostId'].should be_a(String)
      actual['id'].should be_an(Integer)
      actual['imageId'].should be_an(Integer)
      actual['metadata'].should be_a(Hash)
      actual['name'].should be_a(String)
      actual['progress'].should be_an(Integer)
      actual['status'].should be_a(String)
    end

  end
  describe 'failure' do

    it "should raise a NotFound error if the server does not exist" do
      lambda {
        Rackspace[:servers].get_server_details(0)
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end