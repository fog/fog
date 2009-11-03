require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_images_detail' do
  describe 'success' do

    it "should return proper attributes" do
      actual = servers.list_images_details
      actual['images'].should be_an(Array)
      image = actual['images'].first
      image['created'].should be_a(String)
      image['id'].should be_an(Integer)
      image['name'].should be_a(String)
      image['status'].should be_a(String)
      image['updated'].should be_a(String)
    end

  end
end