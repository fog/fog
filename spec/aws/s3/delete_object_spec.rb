require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.delete_object' do

  before(:all) do
    s3.put_bucket('fogdeleteobject')
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    s3.put_object('fogdeleteobject', 'fog_delete_object', file)
  end

  after(:all) do
    s3.delete_bucket('fogdeleteobject')
  end

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.delete_object('fogdeleteobject', 'fog_delete_object')
  end

end