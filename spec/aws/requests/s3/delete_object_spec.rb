require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.delete_object' do

  before(:all) do
    @s3 = Fog::AWS::S3.gen
    @s3.put_bucket('fogdeleteobject')
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    @s3.put_object('fogdeleteobject', 'fog_delete_object', file)
  end

  after(:all) do
    @s3.delete_bucket('fogdeleteobject')
  end

  it 'should return proper attributes' do
    actual = @s3.delete_object('fogdeleteobject', 'fog_delete_object')
    actual.status.should == 204
  end

  it 'should raise NotFound error if the bucket does not exist' do
    lambda {
      @s3.delete_object('fognotabucket', 'fog_delete_object')
    }.should raise_error(Fog::Errors::NotFound)
  end

  it 'should not raise an error if the object does not exist' do
    @s3.delete_object('fogdeleteobject', 'fog_not_an_object')
  end

end