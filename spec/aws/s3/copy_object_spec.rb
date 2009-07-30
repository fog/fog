require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.copy_object' do

  before(:all) do
    s3.put_bucket('fogcopyobjectsource')
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    s3.put_object('fogcopyobjectsource', 'fog_copy_object_source', file)
    s3.put_bucket('fogcopyobjectdestination')
  end

  after(:all) do
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