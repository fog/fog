require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.get_server_details' do
  describe 'success' do

    it "should return proper attributes" do
      p servers.get_server_details(id)
    end

  end
end