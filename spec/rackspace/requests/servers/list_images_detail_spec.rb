require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_images_detail' do
  describe 'success' do

    it "should return proper attributes" do
      actual = Rackspace[:servers].list_images_detail.body
      actual['images'].should be_an(Array)
      image = actual['images'].first
      image['id'].should be_an(Integer)
      image['name'].should be_a(String)
      image['status'].should be_a(String)
      image['updated'].should be_a(String)
    end

  end
end