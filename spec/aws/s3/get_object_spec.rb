require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.get_object' do

  before(:all) do
    s3.put_bucket('foggetobject')
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    s3.put_object('foggetobject', 'fog_get_object', file)
  end

  after(:all) do
    s3.delete_object('foggetobject', 'fog_get_object')
    s3.delete_bucket('foggetobject')
  end

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.get_object('foggetobject', 'fog_get_object')
  end

end