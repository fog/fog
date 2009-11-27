require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_images' do
  describe 'success' do

    it "should return proper attributes" do
      actual = slicehost.get_images.body
      actual['images'].should be_an(Array)
      image = actual['images'].first
      image['id'].should be_an(Integer)
      image['name'].should be_a(String)
    end

  end
end
