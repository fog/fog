require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.copy_object' do
  describe 'success' do

    before(:each) do
      s3.put_bucket('fogcopyobjectsource')
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      s3.put_object('fogcopyobjectsource', 'fog_copy_object_source', file)
      s3.put_bucket('fogcopyobjectdestination')
    end

    after(:each) do
      s3.delete_object('fogcopyobjectdestination', 'fog_copy_object_destination')
      s3.delete_bucket('fogcopyobjectdestination')
      s3.delete_object('fogcopyobjectsource', 'fog_copy_object_source')
      s3.delete_bucket('fogcopyobjectsource')
    end

    it 'should return proper attributes' do
      actual = s3.copy_object(
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
        s3.copy_object(
          'fognotabucket', 'fog_copy_object_source',
          'fogcopyobjectdestination', 'fog_copy_object_destination'
        )
      }.should raise_error(Fog::Errors::NotFound)
    end

    it 'should raise a NotFound error if the source_object does not exist' do
      lambda {
        s3.copy_object(
          'fogcopyobjectsource', 'fog_not_an_object',
          'fogcopyobjectdestination', 'fog_copy_object_destination'
        )
      }.should raise_error(Fog::Errors::NotFound)
    end

    it 'should raise a NotFound error if the target_bucket does not exist' do
      lambda {
        s3.copy_object(
          'fogcopyobjectsource', 'fog_copy_object_source',
          'fognotabucket', 'fog_copy_object_destination'
        )
      }.should raise_error(Fog::Errors::NotFound)
    end

  end

end
