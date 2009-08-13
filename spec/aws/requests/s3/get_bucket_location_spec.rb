require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.get_bucket_location' do

  before(:all) do
    s3.put_bucket('foggetlocation', 'LocationConstraint' => 'EU')
  end

  after(:all) do
    eu_s3.delete_bucket('foggetlocation')
  end

  it 'should return proper attributes' do
    actual = s3.get_bucket_location('foggetlocation')
    actual.status.should == 200
    actual.body['LocationConstraint'].should == 'EU'
  end

end