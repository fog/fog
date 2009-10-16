require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.list_images' do
  describe 'success' do

    it "should return proper attributes" do
      p servers.list_images
    end

  end
end