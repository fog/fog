require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.delete_server' do
  describe 'success' do

    it "should return proper attributes" do
      p servers.delete_server(id)
    end

  end
end