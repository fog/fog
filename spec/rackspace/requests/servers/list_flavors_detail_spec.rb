require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_flavors_detail' do
  describe 'success' do

    it "should return proper attributes" do
      actual = servers.list_flavors_detail.body
      actual['flavors'].should be_an(Array)
      flavor = actual['flavors'].first
      flavor['disk'].should be_an(Integer)
      flavor['id'].should be_an(Integer)
      flavor['name'].should be_a(String)
      flavor['ram'].should be_an(Integer)
    end

  end
end
