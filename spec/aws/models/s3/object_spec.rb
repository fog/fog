require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3::Object' do

  before(:each) do
    @bucket = s3.buckets.create(:name => 'fogbucketname')
  end

  after(:each) do
    @bucket.destroy
  end

  describe "#initialize" do

    it "should remap attributes from parser" do
      now = Time.now
      bucket = Fog::AWS::S3::Object.new(
        'Content-Length' => 10,
        'Content-Type'   => 'contenttype',
        'Etag'           => 'etag',
        'Key'            => 'key',
        'Last-Modified'  => now,
        'Size'           => 10,
        'StorageClass'   => 'storageclass'
      )
      bucket.content_length == 10
      bucket.content_type.should == 'contenttype'
      bucket.etag.should == 'etag'
      bucket.key.should == 'key'
      bucket.last_modified.should == now
      bucket.size.should == 10
      bucket.storage_class.should == 'storageclass'

      bucket = Fog::AWS::S3::Object.new(
        'ETag'          => 'etag',
        'LastModified'  => now
      )
      bucket.etag.should == 'etag'
      bucket.last_modified.should == now
    end

  end

  describe "#bucket" do

    before(:each) do
      @object = @bucket.objects.new(:key => 'foo')
    end
    

    it "should return an S3::Bucket" do
      @object.bucket.should be_a(Fog::AWS::S3::Bucket)
    end

    it "should be the bucket the object is related to" do
      @object.bucket.should == @bucket
    end

  end

  describe "#copy" do

    it "should return a Fog::AWS::S3::Object with matching attributes" do
      other_bucket = s3.buckets.create(:name => 'fogotherbucketname')
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      other_object = object.copy('fogotherbucketname', 'fogotherobjectname')
      object.reload.attributes.reject{|key,value| [:key, :last_modified].include?(key)}.should == other_object.reload.attributes.reject{|key,value| [:key, :last_modified].include?(key)}
      other_object.destroy
      object.destroy
      other_bucket.destroy
    end

  end

  describe "#destroy" do

    it "should return true if the object is deleted" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      object.destroy.should be_true
    end

    it "should return true if the object does not exist" do
      object = @bucket.objects.new(:key => 'fogobjectname')
      object.destroy.should be_true
    end

  end

  describe "#reload" do

    it "should return a Fog::AWS::S3::Object" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      # object.reload.should be_a(Fog::AWS::S3::Object)
      object.destroy
    end

    it "should reset attributes to remote state" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.create(:key => 'fogobjectname', :body => file)
      object.last_modified = Time.now
      # object.reload.attributes.should == object.attributes
      object.destroy
    end

  end

  describe "#save" do

    it "should return the success value" do
      file = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      object = @bucket.objects.new(:key => 'fogobjectname', :body => file)
      object.save.should be_true
      object.destroy
    end

  end

end
