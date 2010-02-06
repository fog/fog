require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_image' do
  describe 'success' do

    it "should return proper attributes" do
      actual = Slicehost[:slices].get_image.body
      actual['id'].should be_an(Integer)
      actual['name'].should be_a(String)
    end

  end

  describe 'failure' do

    it "should raise a Forbidden error if the flavor does not exist" do
      lambda {
        Slicehost[:slices].get_image(0)
      }.should raise_error(Excon::Errors::Forbidden)
    end

  end

end
