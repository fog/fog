require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_slices' do
  describe 'success' do

    before(:each) do
      # flavor_id 1: 256 ram, image_id 3: Gentoo 2008.0
      @slice_id = Slicehost[:slices].create_slice(1, 3, 'fog_create_slice').body['id']
    end

    after(:each) do
      eventually(128) do
        Slicehost[:slices].delete_slice(@slice_id)
      end
    end

    it "should return proper attributes" do
      actual = Slicehost[:slices].get_slices.body
      actual['slices'].should be_an(Array)
      slice = actual['slices'].first
      slice['addresses'].should be_a(Array)
      # slice['backup-id'].should be_an(Integer)
      slice['bw-in'].should be_a(Float)
      slice['bw-out'].should be_a(Float)
      slice['flavor-id'].should be_an(Integer)
      slice['id'].should be_an(Integer)
      slice['image-id'].should be_an(Integer)
      slice['name'].should be_an(String)
      slice['progress'].should be_an(Integer)
      slice['status'].should be_an(String)
    end

  end
end
