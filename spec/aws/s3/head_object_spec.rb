require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.head_object' do

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.head_object('fogheadobjectbucket', 'fogheadobjectobject')
  end

end