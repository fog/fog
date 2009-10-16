require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_flavors' do
  describe 'success' do

    it "should return proper attributes" do
      p servers.list_flavors
    end

  end
end