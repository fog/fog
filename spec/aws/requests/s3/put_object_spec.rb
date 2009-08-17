require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.put_object' do

  before(:all) do
    @s3 = Fog::AWS::S3.gen
    @s3.put_bucket('fogputobject')
  end

  after(:all) do
    @s3.delete_object('fogputobject', 'fog_put_object')
    @s3.delete_bucket('fogputobject')
  end

  it 'should return proper attributes' do
    file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
    actual = @s3.put_object('fogputobject', 'fog_put_object', file)
    actual.status.should == 200
  end

  it 'should raise a NotFound error if the bucket does not exist' do
    lambda {
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      @s3.put_object('fognotabucket', 'fog_put_object', file)
    }.should raise_error(Fog::Errors::NotFound)
  end

  it 'should not raise an error if the object already exists' do
    file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
    actual = @s3.put_object('fogputobject', 'fog_put_object', file)
    actual.status.should == 200
  end

end