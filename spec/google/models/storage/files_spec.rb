require File.dirname(__FILE__) + '/../../../spec_helper'
require 'pp'

describe 'Fog::Google::Storage::Files' do

  before(:each) do
    dirname = "fogdirname"
#    dirname = "fog#{Time.now.to_f}"
    @directory = Google[:storage].directories.create(:key => dirname)
  end

  after(:each) do
    until @directory.files.reload.empty?
      @directory.files.each {|file| file.destroy}
    end
    @directory.destroy
  end

  describe "#initialize" do

    it "should remap attributes from parser" do
      files = Fog::Google::Storage::Files.new(
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
      directory = Google[:storage].directories.new(:key => 'notadirectory')
      directory.files.all.should be_nil
    end

    it "should return 10 files and report truncated" do
      10.times do |n|
        @directory.files.create(:key => "file-#{n}")
      end
      response = @directory.files.all
      response.should have(10).items
      response.is_truncated.should_not be_true
    end

    # it "should limit the max_keys to 10" do
    #   10.times do |n|
    #     @directory.files.create(:key => "file-#{n}")
    #   end
    #   response = @directory.files.all(:max_keys => 20)
    #   response.should have(10).items
    #   response.max_keys.should == 20
    #   response.is_truncated.should be_true
    # end

  end

  describe "#create" do

    it "should exist on google storage" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      @directory.files.get('fogfilename').should_not be_nil
      file.destroy
    end

  end

  describe "#get" do

    before(:each) do
      @data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      @file = @directory.files.create(:key => 'fogfilename', :body => @data)
    end

    after(:each) do
      @file.destroy
    end

    it "should return a Fog::Google::Storage::File with metadata and data" do
      @file.reload
      @file.body.should_not be_nil
#      @file.content_length.should_not be_nil
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

    it "should return a url" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.new(:key => 'fogfilename', :body => data)
      file.save({'x-goog-acl' => 'public-read'})
      url = @directory.files.get_url('fogfilename', Time.now + 60 * 10)
      unless Fog.mocking?
        open(url).read.should == File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r').read
      end
      file.destroy
    end

  end

  describe "#head" do

    it "should return a Fog::Google::Storage::File with metadata" do
      data = File.open(File.dirname(__FILE__) + '/../../../lorem.txt', 'r')
      file = @directory.files.create(:key => 'fogfilename', :body => data)
      file = @directory.files.get('fogfilename')
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
