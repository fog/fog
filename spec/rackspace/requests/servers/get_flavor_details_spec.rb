require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.get_flavor_details' do
  describe 'success' do

    it "should return proper attributes" do
      actual = servers.get_flavor_details(1).body['flavor']
      actual['disk'].should be_an(Integer)
      actual['id'].should be_an(Integer)
      actual['name'].should be_a(String)
      actual['ram'].should be_an(Integer)
    end

  end
end
