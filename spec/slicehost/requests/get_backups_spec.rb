require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.get_backups' do
  describe 'success' do

    it "should return proper attributes" do
      actual = slicehost.get_backups.body
      actual['backups'].should be_an(Array)
      backup = actual['backups'].first
      # backup['date'].should be_a(String)
      # backup['id'].should be_an(Integer)
      # backup['name'].should be_an(String)
      # backup['slice-id'].should be_an(Integer)
    end

  end
end
