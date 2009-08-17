require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.head_object' do

  before(:all) do
    @s3 = Fog::AWS::S3.gen
    @s3.put_bucket('fogheadobject')
    file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
    @s3.put_object('fogheadobject', 'fog_head_object', file)
  end

  after(:all) do
    @s3.delete_object('fogheadobject', 'fog_head_object')
    @s3.delete_bucket('fogheadobject')
  end

  it 'should return proper attributes' do
    actual = @s3.head_object('fogheadobject', 'fog_head_object')
    actual.status.should == 200
    file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
    data = file.read
    actual.headers['Content-Length'].should == data.length.to_s
    actual.headers['ETag'].should be_a(String)
    actual.headers['Last-Modified'].should be_a(String)
  end

end