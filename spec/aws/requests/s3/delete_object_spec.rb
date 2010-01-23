require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.delete_object' do
  describe 'success' do

    before(:each) do
      AWS[:s3].put_bucket('fogdeleteobject')
      AWS[:s3].put_object('fogdeleteobject', 'fog_delete_object', lorem_file)
    end

    after(:each) do
      AWS[:s3].delete_bucket('fogdeleteobject')
    end

    it 'should return proper attributes' do
      actual = AWS[:s3].delete_object('fogdeleteobject', 'fog_delete_object')
      actual.status.should == 204
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        AWS[:s3].delete_object('fognotabucket', 'fog_delete_object')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should not raise an error if the object does not exist' do
      AWS[:s3].put_bucket('fogdeleteobject')
      AWS[:s3].delete_object('fogdeleteobject', 'fog_not_an_object')
      AWS[:s3].delete_bucket('fogdeleteobject')
    end

  end
end
