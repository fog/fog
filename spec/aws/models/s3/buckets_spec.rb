require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Buckets' do

  describe "#all" do

    it "should return a Fog::AWS::S3::Buckets" do
      s3.buckets.all.should be_a(Fog::AWS::S3::Buckets)
    end

    it "should include persisted buckets" do
      bucket = s3.buckets.create(:name => 'fogbucketname')
      s3.buckets.all.keys.should include('fogbucketname')
      bucket.destroy
    end

  end

  describe "#create" do

    before(:each) do
      @bucket = s3.buckets.create(:name => 'fogbucketname')
    end

    after(:each) do
      @bucket.destroy
    end

    it "should return a Fog::AWS::S3::Bucket" do
      @bucket.should be_a(Fog::AWS::S3::Bucket)
    end

    it "should exist on s3" do
      s3.buckets.get(@bucket.name).should_not be_nil
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::S3::Bucket if a matching bucket exists" do
      bucket = s3.buckets.create(:name => 'fogbucketname')
      get = s3.buckets.get('fogbucketname')
      bucket.attributes.should == get.attributes
      bucket.destroy
    end

    it "should return memoized bucket on subsequent gets" do
      bucket = s3.buckets.create(:name => 'fogbucketname')
      get1 = s3.buckets.get('fogbucketname')
      s3.should_not_receive(:get_bucket)
      get2 = s3.buckets.get('fogbucketname')
      get1.attributes.should == get2.attributes
      bucket.destroy
    end

    it "should return nil if no matching bucket exists" do
      s3.buckets.get('fogbucketname').should be_nil
    end

  end

  describe "#new" do

    it "should return a Fog::AWS::S3::Bucket" do
      s3.buckets.new.should be_a(Fog::AWS::S3::Bucket)
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::S3::Buckets" do
      s3.buckets.all.should be_a(Fog::AWS::S3::Buckets)
    end

  end

end
