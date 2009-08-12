require File.dirname(__FILE__) + '/../../spec_helper'

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
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    actual = @s3.put_object('fogputobject', 'fog_put_object', file)
    actual.status.should == 200
  end

end