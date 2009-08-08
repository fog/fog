require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.buckets' do

  it "should return buckets from all" do
    p s3.buckets.all
  end

  it "should return bucket from get" do
    p s3.buckets.get('monki')
  end

  it "should create bucket" do
    p @bucket = s3.buckets.create(:name => 'fogbucketstest')
    p @bucket.delete
  end

  it "should get/put request payment" do
    p @bucket = s3.buckets.create(:name => 'fogbucketspaymenttest')
    p @bucket.payer = 'BucketOwner'
    p @bucket.payer
    p @bucket.delete
  end

end