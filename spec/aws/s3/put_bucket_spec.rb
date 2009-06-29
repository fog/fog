require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.put_bucket' do

  after(:all) do
    s3.delete_bucket('fogputbucket')
  end

  it 'should not include fogputbucket in get_service buckets before put_bucket' do
    lambda { s3.get_service }.should_not eventually { |expected| expected.body[:buckets].collect { |bucket| bucket[:name] }.should_not include('fogputbucket') }
  end

  it 'should return proper attributes' do
    actual = s3.put_bucket('fogputbucket')
    actual.status.should == 200
  end

  it 'should include fogputbucket in get_service buckets after put_bucket' do
    lambda { s3.get_service }.should eventually { |expected| expected.body[:buckets].collect { |bucket| bucket[:name] }.should include('fogputbucket') }
  end

end
