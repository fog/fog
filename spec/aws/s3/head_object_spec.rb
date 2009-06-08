require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.head_object' do

  before(:all) do
    s3.put_bucket('fogheadobject')
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    s3.put_object('fogheadobject', 'fog_head_object', file)
  end

  after(:all) do
    s3.delete_object('fogheadobject', 'fog_head_object')
    s3.delete_bucket('fogheadobject')
  end

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.head_object('fogheadobject', 'fog_head_object')
  end

end