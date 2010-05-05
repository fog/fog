require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::File' do

  before(:each) do
    @directory = AWS[:s3].directories.create(:key => 'fogdirectoryname')
  end

  after(:each) do
    @directory.destroy
  end

  describe "#initialize" do

    it "should remap attributes from parser" do
      now = Time.now
      directory = Fog::AWS::S3::File.new(
        'Content-Length' => 10,
        'Content-Type'   => 'contenttype',
        'Etag'           => 'etag',
        'Key'            => 'key',
        'Last-Modified'  => now,
        'Size'           => 10,
        'StorageClass'   => 'storageclass'
      )
      directory.content_length == 10
      directory.content_type.should == 'contenttype'
      directory.etag.should == 'etag'
      directory.key.should == 'key'
      directory.last_modified.should == now
      directory.size.should == 10
      directory.storage_class.should == 'storageclass'

      directory = Fog::AWS::S3::File.new(
        'ETag'          => 'etag',
        'LastModified'  => now
      )
      directory.etag.should == 'etag'
      directory.last_modified.should == now
    end

  end

  describe "#directory" do

    it "should be the directory the file is related to" do
      @file = @directory.files.new(:key => 'foo')
      @file.directory.should == @directory
    end

  end

  describe "#copy" do

    it "should return a Fog::AWS::S3::File with matching attributes" do
      other_directory = AWS[:s3].directories.create(:key => 'fogotherdirectoryname')
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      other_file = file.copy('fogotherdirectoryname', 'fogotherfilename')
      file.reload.attributes.reject{|key,value| [:key, :last_modified].include?(key)}.should == other_file.reload.attributes.reject{|key,value| [:key, :last_modified].include?(key)}
      other_file.destroy
      file.destroy
      other_directory.destroy
    end

  end

  describe "#destroy" do

    it "should return true if the file is deleted" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      file.destroy.should be_true
    end

    it "should return true if the file does not exist" do
      file = @directory.files.new(:key => 'fogfilename')
      file.destroy.should be_true
    end

  end

  describe "#reload" do

    it "should reset attributes to remote state" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      file.last_modified = Time.now
      file.reload.attributes.should == file.attributes
      file.destroy
    end

  end

  describe "#save" do

    it "should return the success value" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.new(:key => 'fogfilename', :body => data)
      file.save.should be_true
      file.destroy
    end

  end

end
