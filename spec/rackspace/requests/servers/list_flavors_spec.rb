require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_flavors' do
  describe 'success' do

    it "should return proper attributes" do
      actual = Rackspace[:servers].list_flavors.body
      actual['flavors'].should be_an(Array)
      flavor = actual['flavors'].first
      flavor['id'].should be_an(Integer)
      flavor['name'].should be_a(String)
    end

  end
end
