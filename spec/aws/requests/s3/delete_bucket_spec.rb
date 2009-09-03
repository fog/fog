require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.delete_bucket' do
  describe 'success' do

    before(:each) do
      s3.put_bucket('fogdeletebucket')
    end

    it 'should return proper attributes' do
      actual = s3.delete_bucket('fogdeletebucket')
      actual.status.should == 204
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        s3.delete_bucket('fognotabucket')
      }.should raise_error(Fog::Errors::NotFound)
    end

    it 'should raise a Conflict error if the bucket is not empty' do
      s3.put_bucket('fogdeletebucket')
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      s3.put_object('fogdeletebucket', 'fog_delete_object', file)
      lambda {
        s3.delete_bucket('fogdeletebucket')
      }.should raise_error(Fog::Errors::Conflict)
      s3.delete_object('fogdeletebucket', 'fog_delete_object')
      s3.delete_bucket('fogdeletebucket')
    end

  end
end
