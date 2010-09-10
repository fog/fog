require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.delete_object' do
  describe 'success' do

    before(:each) do
      AWS[:storage].put_bucket('fogdeleteobject')
      AWS[:storage].put_object('fogdeleteobject', 'fog_delete_object', lorem_file)
    end

    after(:each) do
      AWS[:storage].delete_bucket('fogdeleteobject')
    end

    it 'should return proper attributes' do
      actual = AWS[:storage].delete_object('fogdeleteobject', 'fog_delete_object')
      actual.status.should == 204
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        AWS[:storage].delete_object('fognotabucket', 'fog_delete_object')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should not raise an error if the object does not exist' do
      AWS[:storage].put_bucket('fogdeleteobject')
      AWS[:storage].delete_object('fogdeleteobject', 'fog_not_an_object')
      AWS[:storage].delete_bucket('fogdeleteobject')
    end

  end
end
