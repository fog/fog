require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.get_bucket' do
  describe 'success' do

    before(:all) do
      Google[:storage].put_bucket('foggetbucket')
      Google[:storage].put_object('foggetbucket', 'fog_object', lorem_file)
      Google[:storage].put_object('foggetbucket', 'fog_other_object', lorem_file)
    end

    after(:all) do
      Google[:storage].delete_object('foggetbucket', 'fog_object')
      Google[:storage].delete_object('foggetbucket', 'fog_other_object')
      Google[:storage].delete_bucket('foggetbucket')
    end

    it 'should return proper attributes' do
      actual = Google[:storage].get_bucket('foggetbucket')
      actual.body['IsTruncated'].should == false
      actual.body['Marker'].should be_nil
      actual.body['MaxKeys'].should be_an(Integer)
      actual.body['Name'].should be_a(String)
      actual.body['Prefix'].should be_nil
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
      actual = Google[:storage].get_bucket('foggetbucket', 'marker' => 'fog_object')
      actual.body['IsTruncated'].should == false
      actual.body['Marker'].should be_a(String)
      actual.body['MaxKeys'].should be_an(Integer)
      actual.body['Name'].should be_a(String)
      actual.body['Prefix'].should be_nil
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

    it 'should accept max-keys option' do
      actual = Google[:storage].get_bucket('foggetbucket', 'max-keys' => 1)
      actual.body['IsTruncated'].should == true
      actual.body['Marker'].should be_nil
      actual.body['MaxKeys'].should be_an(Integer)
      actual.body['Name'].should be_a(String)
      actual.body['Prefix'].should be_nil
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
      actual = Google[:storage].get_bucket('foggetbucket', 'prefix' => 'fog_ob')
      actual.body['IsTruncated'].should == false
      actual.body['Marker'].should be_nil
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

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        Google[:storage].get_bucket('fognotabucket')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should request non-subdomain buckets and raise a NotFound error' do
      lambda {
        Google[:storage].get_bucket('A-invalid--name')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
