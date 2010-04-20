require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Files' do

  before(:each) do
    @directory = AWS[:s3].directories.create(:name => 'fogdirectoryname')
  end

  after(:each) do
    @directory.destroy
  end

  describe "#initialize" do

    it "should remap attributes from parser" do
      files = Fog::AWS::S3::Files.new(
        'IsTruncated' => true,
        'Marker'      => 'marker',
        'MaxKeys'     => 1,
        'Prefix'      => 'prefix'
      )
      files.is_truncated.should == true
      files.marker.should == 'marker'
      files.max_keys.should == 1
      files.prefix.should == 'prefix'
    end

  end

  describe "#all" do

    it "should return nil if the directory does not exist" do
      directory = AWS[:s3].directories.new(:name => 'notadirectory')
      directory.files.all.should be_nil
    end

  end

  describe "#create" do

    it "should exist on s3" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      @directory.files.get('fogfilename').should_not be_nil
      file.destroy
    end

  end

  describe "#get" do

    before(:each) do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      @file = @directory.files.create(:key => 'fogfilename', :body => data)
    end

    after(:each) do
      @file.destroy
    end

    it "should return a Fog::AWS::S3::File with metadata and data" do
      @file.reload
      @file.body.should_not be_nil
      @file.content_length.should_not be_nil
      @file.etag.should_not be_nil
      @file.last_modified.should_not be_nil
      @file.destroy
    end

    it "should return chunked data if given a block" do
      data = ''
      @directory.files.get('fogfilename') do |chunk|
        data << chunk
      end
      data.should == File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r').read
    end

  end

  describe "#get_url" do

    it "should return a signed expiring url" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      url = @directory.files.get_url('fogfilename', Time.now + 60 * 10)
      url.should include("fogfilename", "Expires")
      unless Fog.mocking?
        open(url).read.should == File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r').read
      end
      file.destroy
    end

  end

  describe "#head" do

    it "should return a Fog::AWS::S3::File with metadata" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      file = @directory.files.get('fogfilename')
      file.content_length.should_not be_nil
      file.etag.should_not be_nil
      file.last_modified.should_not be_nil
      file.destroy
    end

  end

  describe "#reload" do

    it "should reload data" do
      @directory.files.reload.should == @directory.files
    end

  end

end
