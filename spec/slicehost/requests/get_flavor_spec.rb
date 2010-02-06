require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_flavor' do
  describe 'success' do

    it "should return proper attributes" do
      actual = Slicehost[:slices].get_flavor(1).body
      actual['id'].should be_an(Integer)
      actual['name'].should be_an(String)
      actual['price'].should be_a(Integer)
      actual['ram'].should be_an(Integer)
    end

  end
  describe 'failure' do

    it "should raise a Forbidden error if the flavor does not exist" do
      lambda {
        Slicehost[:slices].get_flavor(0)
      }.should raise_error(Excon::Errors::Forbidden)
    end

  end
end
