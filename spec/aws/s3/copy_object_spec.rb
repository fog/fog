require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.copy_object' do

  it 'should return proper attributes' do
    p 'SHOULD CHECK FOR PROPER ATTRIBUTES'
    p s3.copy_object(
      'fogcopyobjectsourcebucket', 'fogcopyobjectsourceobject',
      'fogcopyobjectdestinationbucket', 'fogcopyobjectdestinationobject'
    )
  end

end