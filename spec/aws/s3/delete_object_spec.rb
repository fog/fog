require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.delete_object' do

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.delete_object('fogdeleteobjectbucket', 'fogdeleteobjectobject')
  end

end