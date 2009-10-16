require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_servers_details' do
  describe 'success' do

    it "should return proper attributes" do
      p servers.list_servers_details
    end

  end
end