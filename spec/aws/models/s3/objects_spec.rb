require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Objects' do

  before(:each) do
    @bucket = s3.buckets.create(:name => 'fogbucketname')
  end

  after(:each) do
    @bucket.destroy
  end

  describe "#initialize" do

    it "should remap attributes from parser" do
      objects = Fog::AWS::S3::Objects.new(
        'IsTruncated' => true,
        'Marker'      => 'marker',
        'MaxKeys'     => 1,
        'Prefix'      => 'prefix'
      )
      objects.is_truncated.should == true
      objects.marker.should == 'marker'
      objects.max_keys.should == 1
      objects.prefix.should == 'prefix'
    end

  end

  describe "#all" do

    it "should return a Fog::AWS::S3::Objects" do
      @bucket.objects.all.should be_a(Fog::AWS::S3::Objects)
    end

    it "should include persisted objects" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      @bucket.objects.keys.should include('fogobjectname')
      object.destroy
    end

  end

  describe "#bucket" do

    it "should return a Fog::AWS::S3::Bucket" do
      @bucket.objects.bucket.should be_a(Fog::AWS::S3::Bucket)
    end

    it "should be the bucket the object is related to" do
      @bucket.objects.bucket.should == @bucket
    end
  end

  describe "#create" do

    it "should return a Fog::AWS::S3::Object" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      object.should be_a(Fog::AWS::S3::Object)
      object.destroy
    end

    it "should exist on s3" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      @bucket.objects.get('fogobjectname').should_not be_nil
      object.destroy
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::S3::Object with metadata and data"

  end

  describe "#head" do

    it "should return a Fog::AWS::S3::Object with metadata"

  end

  describe "#new" do

    it "should return a Fog::AWS::S3::Object" do
      @bucket.objects.new.should be_a(Fog::AWS::S3::Object)
    end

  end

  describe "#reload" do

    it "should reload from s3"

  end

end
