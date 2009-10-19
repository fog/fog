require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.update_server' do
  describe 'success' do

    it "should return proper attributes" do
      pending
      p servers.update_server(id, :name => 'foo', :adminPass => 'bar')
    end

  end
end