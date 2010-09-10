require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.copy_object' do
  describe 'success' do

    before(:each) do
      AWS[:storage].put_bucket('fogcopyobjectsource')
      AWS[:storage].put_object('fogcopyobjectsource', 'fog_copy_object_source', lorem_file)
      AWS[:storage].put_bucket('fogcopyobjectdestination')
    end

    after(:each) do
      AWS[:storage].delete_object('fogcopyobjectdestination', 'fog_copy_object_destination')
      AWS[:storage].delete_bucket('fogcopyobjectdestination')
      AWS[:storage].delete_object('fogcopyobjectsource', 'fog_copy_object_source')
      AWS[:storage].delete_bucket('fogcopyobjectsource')
    end

    it 'should return proper attributes' do
      actual = AWS[:storage].copy_object(
        'fogcopyobjectsource', 'fog_copy_object_source',
        'fogcopyobjectdestination', 'fog_copy_object_destination'
      )
      actual.status.should == 200
      actual.body['ETag'].should be_a(String)
      actual.body['LastModified'].should be_a(Time)
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the source_bucket does not exist' do
      lambda {
        AWS[:storage].copy_object(
          'fognotabucket', 'fog_copy_object_source',
          'fogcopyobjectdestination', 'fog_copy_object_destination'
        )
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a NotFound error if the source_object does not exist' do
      lambda {
        AWS[:storage].copy_object(
          'fogcopyobjectsource', 'fog_not_an_object',
          'fogcopyobjectdestination', 'fog_copy_object_destination'
        )
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a NotFound error if the target_bucket does not exist' do
      lambda {
        AWS[:storage].copy_object(
          'fogcopyobjectsource', 'fog_copy_object_source',
          'fognotabucket', 'fog_copy_object_destination'
        )
      }.should raise_error(Excon::Errors::NotFound)
    end

  end

end
