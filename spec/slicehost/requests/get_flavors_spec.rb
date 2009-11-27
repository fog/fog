require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_flavors' do
  describe 'success' do

    it "should return proper attributes" do
      actual = slicehost.get_flavors.body
      actual['flavors'].should be_an(Array)
      flavor = actual['flavors'].first
      flavor['id'].should be_an(Integer)
      flavor['name'].should be_an(String)
      flavor['price'].should be_a(Integer)
      flavor['ram'].should be_an(Integer)
    end

  end
end
