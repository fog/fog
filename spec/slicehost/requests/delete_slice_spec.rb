require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.delete_slice' do
  describe 'success' do

    before(:each) do
      # flavor_id 1: 256 ram, image_id 3: Gentoo 2008.0
      @slice_id = slicehost.create_slice(1, 3, 'fog_slice').body['id']
    end

    it "should return proper attributes" do
      eventually(128) do
        actual = slicehost.delete_slice(@slice_id)
      end
    end

  end
end
