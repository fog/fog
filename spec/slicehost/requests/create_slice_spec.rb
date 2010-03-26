require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.create_slice' do
  describe 'success' do

    after(:each) do
      eventually(128) do
        Slicehost[:slices].delete_slice(@slice_id)
      end
    end

    it "should return proper attributes" do
      # flavor_id 1: 256 ram, image_id 3: Gentoo 2008.0
      actual = Slicehost[:slices].create_slice(1, 3, 'fog_create_slice').body      
      actual['addresses'].should be_a(Array)
      # actual['backup-id'].should be_an(Integer)
      actual['bw-in'].should be_an(Float)
      actual['bw-out'].should be_an(Float)
      actual['flavor-id'].should be_an(Integer)
      actual['id'].should be_an(Integer)
      @slice_id = actual['id']
      actual['image-id'].should be_an(Integer)
      actual['name'].should be_an(String)
      actual['progress'].should be_an(Integer)
      actual['root-password'].should be_a(String)
      actual['status'].should be_an(String)
    end

  end
end
