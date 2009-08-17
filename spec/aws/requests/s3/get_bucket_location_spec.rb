require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.get_bucket_location' do

  before(:all) do
    @s3 = Fog::AWS::S3.gen
    @eu_s3 = Fog::AWS::S3.gen(:eu)
    @s3.put_bucket('foggetlocation', 'LocationConstraint' => 'EU')
  end

  after(:all) do
    if Fog.mocking?
      @eu_s3.data = @s3.data
    end
    @eu_s3.delete_bucket('foggetlocation')
  end

  it 'should return proper attributes' do
    actual = @s3.get_bucket_location('foggetlocation')
    actual.status.should == 200
    actual.body['LocationConstraint'].should == 'EU'
  end

  it 'should raise NotFound error if bucket does not exist' do
    lambda {
      @s3.get_bucket_location('fognotabucket')
    }.should raise_error(Fog::Errors::NotFound)
  end

end