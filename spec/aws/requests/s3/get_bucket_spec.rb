require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.get_bucket' do

  before(:all) do
    s3.put_bucket('foggetbucket')
    file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
    s3.put_object('foggetbucket', 'fog_object', file)
    file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
    s3.put_object('foggetbucket', 'fog_other_object', file)
  end

  after(:all) do
    s3.delete_object('foggetbucket', 'fog_object')
    s3.delete_object('foggetbucket', 'fog_other_object')
    s3.delete_bucket('foggetbucket')
  end

  it 'should return proper attributes' do
    actual = s3.get_bucket('foggetbucket')
    actual.body['IsTruncated'].should == false
    actual.body['Marker'].should be_a(String)
    actual.body['MaxKeys'].should be_an(Integer)
    actual.body['Name'].should be_a(String)
    actual.body['Prefix'].should be_a(String)
    actual.body['Contents'].should be_an(Array)
    actual.body['Contents'].length.should == 2
    object = actual.body['Contents'].first
    object['ETag'].should be_a(String)
    object['Key'].should == 'fog_object'
    object['LastModified'].should be_a(Time)
    owner = object['Owner']
    owner['DisplayName'].should be_a(String)
    owner['ID'].should be_a(String)
    object['Size'].should be_an(Integer)
    object['StorageClass'].should be_a(String)
  end

  it 'should accept marker option' do
    actual = s3.get_bucket('foggetbucket', 'marker' => 'fog_object')
    actual.body['IsTruncated'].should == false
    actual.body['Marker'].should be_a(String)
    actual.body['MaxKeys'].should be_an(Integer)
    actual.body['Name'].should be_a(String)
    actual.body['Prefix'].should be_a(String)
    actual.body['Contents'].should be_an(Array)
    actual.body['Contents'].length.should == 1
    object = actual.body['Contents'].first
    object['ETag'].should be_a(String)
    object['Key'].should == 'fog_other_object'
    object['LastModified'].should be_a(Time)
    owner = object['Owner']
    owner['DisplayName'].should be_a(String)
    owner['ID'].should be_a(String)
    object['Size'].should be_an(Integer)
    object['StorageClass'].should be_a(String)
  end

  it 'should respect max-keys option' do
    actual = s3.get_bucket('foggetbucket', 'max-keys' => 1)
    actual.body['IsTruncated'].should == true
    actual.body['Marker'].should be_a(String)
    actual.body['MaxKeys'].should be_an(Integer)
    actual.body['Name'].should be_a(String)
    actual.body['Prefix'].should be_a(String)
    actual.body['Contents'].should be_an(Array)
    actual.body['Contents'].length.should == 1
    object = actual.body['Contents'].first
    object['ETag'].should be_a(String)
    object['Key'].should == 'fog_object'
    object['LastModified'].should be_a(Time)
    owner = object['Owner']
    owner['DisplayName'].should be_a(String)
    owner['ID'].should be_a(String)
    object['Size'].should be_an(Integer)
    object['StorageClass'].should be_a(String)
  end

  it 'should accept prefix option' do
    actual = s3.get_bucket('foggetbucket', 'prefix' => 'fog_ob')
    actual.body['IsTruncated'].should == false
    actual.body['Marker'].should be_a(String)
    actual.body['MaxKeys'].should be_an(Integer)
    actual.body['Name'].should be_a(String)
    actual.body['Prefix'].should be_a(String)
    actual.body['Contents'].should be_an(Array)
    actual.body['Contents'].length.should == 1
    object = actual.body['Contents'].first
    object['ETag'].should be_a(String)
    object['Key'].should == 'fog_object'
    object['LastModified'].should be_a(Time)
    owner = object['Owner']
    owner['DisplayName'].should be_a(String)
    owner['ID'].should be_a(String)
    object['Size'].should be_an(Integer)
    object['StorageClass'].should be_a(String)
  end

  it 'should raise a NotFound error if the bucket does not exist' do
    lambda {
      s3.get_bucket('fognotabucket')
    }.should raise_error(Fog::Errors::NotFound)
  end

end
