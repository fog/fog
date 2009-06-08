require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.put_object' do

  before(:all) do
    s3.put_bucket('fogputobject')
  end

  after(:all) do
    s3.delete_object('fogputobject', 'fog_put_object')
    s3.delete_bucket('fogputobject')
  end

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    p s3.put_object('fogputobject', 'fog_put_object', file)
  end

end