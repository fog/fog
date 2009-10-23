require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Bucket' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      now = Time.now
      bucket = Fog::AWS::S3::Bucket.new(
        'CreationDate' => now,
        'Name'         => 'bucketname'
      )
      bucket.creation_date.should == now
      bucket.name.should == 'bucketname'
    end

  end

  describe "#collection" do

    it "should return a Fog::AWS::S3::Buckets" do
      s3.buckets.new.collection.should be_a(Fog::AWS::S3::Buckets)
    end

    it "should be the buckets the bucket is related to" do
      buckets = s3.buckets
      buckets.new.collection.should == buckets
    end

  end

  describe "#destroy" do

    it "should return true if the bucket is deleted" do
      bucket = s3.buckets.create(:name => 'fogmodelbucket')
      bucket.destroy.should be_true
    end

    it "should return false if the bucket does not exist" do
      bucket = s3.buckets.new(:name => 'fogmodelbucket')
      bucket.destroy.should be_false
    end

  end

  describe "#location" do

    it "should return the location constraint" do
      bucket = s3.buckets.create(:name => 'fogmodeleubucket', :location => 'EU')
      bucket.location.should == 'EU'
      eu_s3.buckets.new(:name => 'fogmodeleubucket').destroy
    end

  end

  describe "#objects" do

    it "should return a Fog::AWS::S3::Objects" do
      bucket = s3.buckets.new(:name => 'fogmodelbucket')
      bucket.objects.should be_an(Fog::AWS::S3::Objects)
    end

  end

  describe "#payer" do

    it "should return the request payment value" do
      bucket = s3.buckets.create(:name => 'fogmodelbucket')
      bucket.payer.should == 'BucketOwner'
      bucket.destroy.should be_true
    end

  end

  describe "#payer=" do

    it "should set the request payment value" do
      bucket = s3.buckets.create(:name => 'fogmodelbucket')
      (bucket.payer = 'Requester').should == 'Requester'
      bucket.destroy.should
    end

  end

  describe "#reload" do

    before(:each) do
      @bucket = s3.buckets.create(:name => 'fogmodelbucket')
      @reloaded = @bucket.reload
    end

    after(:each) do
      @bucket.destroy
    end

    it "should return a Fog::AWS::S3::Bucket" do
      @reloaded.should be_a(Fog::AWS::S3::Bucket)
    end

    it "should reset attributes to remote state" do
      @bucket.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @bucket = s3.buckets.new(:name => 'fogmodelbucket')
    end

    it "should return true when it succeeds" do
      @bucket.save.should be_true
      @bucket.destroy
    end

    it "should not exist in buckets before save" do
      s3.buckets.all.map {|bucket| bucket.name}.include?(@bucket.name).should be_false
    end

    it "should exist in buckets after save" do
      @bucket.save
      s3.buckets.all.map {|bucket| bucket.name}.include?(@bucket.name).should be_true
      @bucket.destroy
    end

  end

end
