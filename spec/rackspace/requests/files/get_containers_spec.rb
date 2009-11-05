require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Files.get_containers' do
  describe 'success' do

    before(:each) do
      files.put_container('container_name')
    end

    after(:each) do
      files.delete_container('container_name')
    end

    it "should return proper attributes" do
      actual = files.get_containers.body
      actual.first['bytes'].should be_an(Integer)
      actual.first['count'].should be_an(Integer)
      actual.first['name'].should be_a(String)
    end

  end
end
