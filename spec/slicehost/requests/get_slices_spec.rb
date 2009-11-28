require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_slices' do
  describe 'success' do

    it "should return proper attributes" do
      actual = slicehost.get_slices.body
      actual['slices'].should be_an(Array)
      slice = actual['slices'].first
      # slice['addresses'].should be_a(Array)
      # slice['backup-id'].should be_an(Integer)
      # slice['bw-in'].should be_an(Integer)
      # slice['bw-out'].should be_an(Integer)
      # slice['flavor-id'].should be_an(Integer)
      # slice['id'].should be_an(Integer)
      # slice['image-id'].should be_an(Integer)
      # slice['name'].should be_an(String)
      # slice['progress'].should be_an(Integer)
      # slice['status'].should be_an(String)
    end

  end
end
