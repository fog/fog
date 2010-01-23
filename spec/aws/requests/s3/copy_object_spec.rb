require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.copy_object' do
  describe 'success' do

    before(:each) do
      AWS[:s3].put_bucket('fogcopyobjectsource')
      AWS[:s3].put_object('fogcopyobjectsource', 'fog_copy_object_source', lorem_file)
      AWS[:s3].put_bucket('fogcopyobjectdestination')
    end

    after(:each) do
      AWS[:s3].delete_object('fogcopyobjectdestination', 'fog_copy_object_destination')
      AWS[:s3].delete_bucket('fogcopyobjectdestination')
      AWS[:s3].delete_object('fogcopyobjectsource', 'fog_copy_object_source')
      AWS[:s3].delete_bucket('fogcopyobjectsource')
    end

    it 'should return proper attributes' do
      actual = AWS[:s3].copy_object(
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
        AWS[:s3].copy_object(
          'fognotabucket', 'fog_copy_object_source',
          'fogcopyobjectdestination', 'fog_copy_object_destination'
        )
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a NotFound error if the source_object does not exist' do
      lambda {
        AWS[:s3].copy_object(
          'fogcopyobjectsource', 'fog_not_an_object',
          'fogcopyobjectdestination', 'fog_copy_object_destination'
        )
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a NotFound error if the target_bucket does not exist' do
      lambda {
        AWS[:s3].copy_object(
          'fogcopyobjectsource', 'fog_copy_object_source',
          'fognotabucket', 'fog_copy_object_destination'
        )
      }.should raise_error(Excon::Errors::NotFound)
    end

  end

end
