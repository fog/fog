require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.buckets' do

  it "should return buckets from all" do
    p s3.buckets.all
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

  it "should push bucket down into objects" do
    p @bucket = s3.buckets.create(:name => 'fogbucketsobjectstest')
    p @bucket.objects.new(:key => 'object')
    p @bucket.objects.all
    p @bucket.delete
  end

end